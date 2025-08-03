-- 요소수 출고주문관리 시스템 Supabase 스키마
-- Created: 2025-01-08
-- Description: DEF shipping order management system database schema

-- =====================================================
-- ENUMS
-- =====================================================

-- 사용자 등급
CREATE TYPE user_grade AS ENUM ('dealer', 'general');

-- 사용자 상태
CREATE TYPE user_status AS ENUM ('pending', 'approved', 'rejected', 'inactive');

-- 주문 상태
CREATE TYPE order_status AS ENUM ('draft', 'pending', 'confirmed', 'shipped', 'completed', 'cancelled');

-- 제품 타입
CREATE TYPE product_type AS ENUM ('box', 'bulk');

-- 배송 방법
CREATE TYPE delivery_method AS ENUM ('direct_pickup', 'delivery');

-- 알림 타입
CREATE TYPE notification_type AS ENUM ('order_status', 'announcement', 'system');

-- =====================================================
-- TABLES
-- =====================================================

-- 1. 사용자 프로필 (Supabase Auth 확장)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    business_number VARCHAR(12) UNIQUE NOT NULL,
    business_name VARCHAR(100) NOT NULL,
    representative_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    grade user_grade NOT NULL DEFAULT 'general',
    status user_status NOT NULL DEFAULT 'pending',
    
    -- 단가 정보 (보안 중요)
    unit_price_box DECIMAL(10,2),         -- 박스 단가 (일반 거래처용)
    unit_price_bulk DECIMAL(10,2),        -- 벌크 단가 (일반 거래처용)
    
    -- 메타 정보
    approved_at TIMESTAMP WITH TIME ZONE,
    approved_by UUID REFERENCES auth.users(id),
    rejected_reason TEXT,
    last_order_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 배송지 정보
CREATE TABLE delivery_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    address_detail VARCHAR(255),
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    is_default BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 제품 마스터 (요소수 정보)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    type product_type NOT NULL,
    unit VARCHAR(20) NOT NULL,           -- 'L' for 리터
    unit_quantity DECIMAL(10,2) NOT NULL, -- 10L or 1000L
    
    -- 대리점 통일 단가
    dealer_price_box DECIMAL(10,2),
    dealer_price_bulk DECIMAL(10,2),
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 주문 정보
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(20) UNIQUE NOT NULL, -- YYMMDDHHmmss-XXX
    user_id UUID NOT NULL REFERENCES profiles(id),
    status order_status NOT NULL DEFAULT 'draft',
    
    -- 주문 상세
    product_type product_type NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    javara_quantity INTEGER DEFAULT 0,      -- 자바라 수량
    return_tank_quantity INTEGER DEFAULT 0,  -- 반납 탱크 수량 (벌크용)
    
    -- 배송 정보
    delivery_date DATE NOT NULL,
    delivery_method delivery_method NOT NULL,
    delivery_address_id UUID REFERENCES delivery_addresses(id),
    delivery_memo TEXT,
    
    -- 가격 정보 (주문 시점 스냅샷)
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    
    -- 상태 추적
    confirmed_at TIMESTAMP WITH TIME ZONE,
    confirmed_by UUID REFERENCES auth.users(id),
    shipped_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancelled_reason TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 거래명세서
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id),
    invoice_number VARCHAR(20) UNIQUE NOT NULL,
    
    -- PDF 파일 정보
    pdf_url TEXT,
    pdf_generated_at TIMESTAMP WITH TIME ZONE,
    
    -- 이메일 발송 정보
    email_sent_at TIMESTAMP WITH TIME ZONE,
    email_sent_to VARCHAR(255),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 재고 관리
CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    location VARCHAR(50) NOT NULL,        -- 'factory' or 'warehouse'
    product_type product_type NOT NULL,
    current_quantity INTEGER NOT NULL DEFAULT 0,
    
    -- 벌크 탱크 관리
    empty_tank_quantity INTEGER DEFAULT 0,
    
    last_updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES auth.users(id),
    
    UNIQUE(location, product_type)
);

-- 7. 재고 변동 이력
CREATE TABLE inventory_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    inventory_id UUID NOT NULL REFERENCES inventory(id),
    change_type VARCHAR(20) NOT NULL,     -- 'in', 'out', 'adjustment'
    change_quantity INTEGER NOT NULL,
    before_quantity INTEGER NOT NULL,
    after_quantity INTEGER NOT NULL,
    reference_id UUID,                    -- order_id 등 참조
    reference_type VARCHAR(20),           -- 'order', 'manual' 등
    memo TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- 8. 공지사항
CREATE TABLE announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    target_grade user_grade[],            -- 대상 등급 배열
    is_important BOOLEAN DEFAULT false,
    
    published_at TIMESTAMP WITH TIME ZONE,
    published_by UUID REFERENCES auth.users(id),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. 알림
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id),
    type notification_type NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    
    -- 참조 정보
    reference_id UUID,
    reference_type VARCHAR(20),
    
    -- 읽음 상태
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,
    
    -- FCM 정보
    fcm_sent BOOLEAN DEFAULT false,
    fcm_sent_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 10. FCM 토큰 관리
CREATE TABLE fcm_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id),
    token TEXT NOT NULL,
    platform VARCHAR(10) NOT NULL,        -- 'ios' or 'android'
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, token)
);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_profiles_business_number ON profiles(business_number);
CREATE INDEX idx_profiles_status ON profiles(status);
CREATE INDEX idx_profiles_grade ON profiles(grade);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_delivery_date ON orders(delivery_date);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can view all profiles" ON profiles
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE id = auth.uid() AND grade = 'dealer' AND status = 'approved'
        )
    );

-- Orders policies
CREATE POLICY "Users can view own orders" ON orders
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders" ON orders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own pending orders" ON orders
    FOR UPDATE USING (
        auth.uid() = user_id AND 
        status IN ('draft', 'pending')
    );

-- Notifications policies
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- 자동 updated_at 갱신
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- updated_at 트리거 생성
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_delivery_addresses_updated_at BEFORE UPDATE ON delivery_addresses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 주문 번호 생성 함수
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS VARCHAR AS $$
DECLARE
    order_date VARCHAR;
    sequence_num INTEGER;
    new_order_number VARCHAR;
BEGIN
    order_date := TO_CHAR(NOW(), 'YYMMDD');
    
    SELECT COUNT(*) + 1 INTO sequence_num
    FROM orders
    WHERE order_number LIKE order_date || '%';
    
    new_order_number := order_date || '-' || LPAD(sequence_num::TEXT, 3, '0');
    
    RETURN new_order_number;
END;
$$ LANGUAGE plpgsql;

-- 재고 차감 함수
CREATE OR REPLACE FUNCTION deduct_inventory(
    p_location VARCHAR,
    p_product_type product_type,
    p_quantity INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    v_current_quantity INTEGER;
    v_inventory_id UUID;
BEGIN
    -- 현재 재고 확인
    SELECT id, current_quantity INTO v_inventory_id, v_current_quantity
    FROM inventory
    WHERE location = p_location AND product_type = p_product_type
    FOR UPDATE;
    
    -- 재고 부족 체크
    IF v_current_quantity < p_quantity THEN
        RETURN FALSE;
    END IF;
    
    -- 재고 차감
    UPDATE inventory
    SET current_quantity = current_quantity - p_quantity
    WHERE id = v_inventory_id;
    
    -- 이력 기록
    INSERT INTO inventory_logs (
        inventory_id, change_type, change_quantity,
        before_quantity, after_quantity, created_by
    ) VALUES (
        v_inventory_id, 'out', -p_quantity,
        v_current_quantity, v_current_quantity - p_quantity, auth.uid()
    );
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- INITIAL DATA
-- =====================================================

-- 제품 마스터 데이터
INSERT INTO products (name, type, unit, unit_quantity, dealer_price_box, dealer_price_bulk)
VALUES 
    ('요소수', 'box', 'L', 10, 50000, NULL),
    ('요소수', 'bulk', 'L', 1000, NULL, 4500000);

-- 초기 재고 설정
INSERT INTO inventory (location, product_type, current_quantity)
VALUES 
    ('factory', 'box', 1000),
    ('factory', 'bulk', 50),
    ('warehouse', 'box', 500),
    ('warehouse', 'bulk', 20);