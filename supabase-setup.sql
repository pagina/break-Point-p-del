-- ============================================================
-- BREAKPOINT PÁDEL - SUPABASE DATABASE SETUP
-- ============================================================
-- Ejecutar este script en: Supabase Dashboard > SQL Editor
-- ============================================================

-- ========== 1. TABLA: GALERÍA DE IMÁGENES ==========
CREATE TABLE IF NOT EXISTS gallery_images (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  url TEXT NOT NULL,
  storage_path TEXT,
  title TEXT DEFAULT '',
  category TEXT DEFAULT 'general',
  display_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 2. TABLA: MENÚ NOMADE BAR ==========
CREATE TABLE IF NOT EXISTS menu_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT DEFAULT '',
  price DECIMAL(10,2),
  emoji TEXT DEFAULT '🍽️',
  available BOOLEAN DEFAULT true,
  display_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 3. TABLA: RESERVAS DE CANCHAS ==========
CREATE TABLE IF NOT EXISTS reservas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre TEXT NOT NULL,
  telefono TEXT NOT NULL,
  email TEXT DEFAULT '',
  sede TEXT NOT NULL,
  fecha DATE NOT NULL,
  hora TEXT NOT NULL,
  estado TEXT DEFAULT 'pendiente',
  notas TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 4. TABLA: MENSAJES DE CONTACTO ==========
CREATE TABLE IF NOT EXISTS mensajes_contacto (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre TEXT NOT NULL,
  email TEXT NOT NULL,
  mensaje TEXT NOT NULL,
  leido BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 5. TABLA: INSCRIPCIONES A TORNEOS ==========
CREATE TABLE IF NOT EXISTS inscripciones_torneos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  jugador1_nombre TEXT NOT NULL,
  jugador1_telefono TEXT NOT NULL,
  jugador2_nombre TEXT DEFAULT '',
  jugador2_telefono TEXT DEFAULT '',
  categoria TEXT NOT NULL,
  torneo TEXT NOT NULL,
  estado TEXT DEFAULT 'pendiente',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 6. TABLA: TURNOS FIJOS ==========
CREATE TABLE IF NOT EXISTS turnos_fijos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre TEXT NOT NULL,
  telefono TEXT NOT NULL,
  email TEXT DEFAULT '',
  sede TEXT NOT NULL,
  dia_semana TEXT NOT NULL,
  hora TEXT NOT NULL,
  cancha TEXT DEFAULT '',
  estado TEXT DEFAULT 'pendiente',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 7. TABLA: CONTENIDO EDITABLE DEL SITIO ==========
CREATE TABLE IF NOT EXISTS site_content (
  id TEXT PRIMARY KEY,
  content TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ========== 8. TABLA: EVENTOS / TORNEOS ==========
CREATE TABLE IF NOT EXISTS eventos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  titulo TEXT NOT NULL,
  descripcion TEXT DEFAULT '',
  fecha DATE,
  imagen_url TEXT DEFAULT '',
  tag TEXT DEFAULT 'Próximamente',
  activo BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE gallery_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE mensajes_contacto ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscripciones_torneos ENABLE ROW LEVEL SECURITY;
ALTER TABLE turnos_fijos ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE eventos ENABLE ROW LEVEL SECURITY;

-- ===== POLÍTICAS PÚBLICAS (lectura) =====

-- Galería: todos pueden ver
CREATE POLICY "gallery_public_read" ON gallery_images
  FOR SELECT USING (true);

-- Menú: todos pueden ver
CREATE POLICY "menu_public_read" ON menu_items
  FOR SELECT USING (true);

-- Contenido del sitio: todos pueden ver
CREATE POLICY "content_public_read" ON site_content
  FOR SELECT USING (true);

-- Eventos: todos pueden ver los activos
CREATE POLICY "eventos_public_read" ON eventos
  FOR SELECT USING (true);

-- ===== POLÍTICAS PÚBLICAS (escritura limitada) =====

-- Reservas: cualquiera puede crear
CREATE POLICY "reservas_public_insert" ON reservas
  FOR INSERT WITH CHECK (true);

-- Mensajes: cualquiera puede crear
CREATE POLICY "mensajes_public_insert" ON mensajes_contacto
  FOR INSERT WITH CHECK (true);

-- Inscripciones: cualquiera puede crear
CREATE POLICY "inscripciones_public_insert" ON inscripciones_torneos
  FOR INSERT WITH CHECK (true);

-- Turnos fijos: cualquiera puede crear
CREATE POLICY "turnos_public_insert" ON turnos_fijos
  FOR INSERT WITH CHECK (true);

-- ===== POLÍTICAS ADMIN (CRUD completo para usuarios autenticados) =====

CREATE POLICY "gallery_admin_all" ON gallery_images
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "menu_admin_all" ON menu_items
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "reservas_admin_all" ON reservas
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "mensajes_admin_all" ON mensajes_contacto
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "inscripciones_admin_all" ON inscripciones_torneos
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "turnos_admin_all" ON turnos_fijos
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "content_admin_all" ON site_content
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "eventos_admin_all" ON eventos
  FOR ALL USING (auth.role() = 'authenticated');

-- ============================================================
-- DATOS INICIALES - MENÚ NOMADE BAR
-- ============================================================

INSERT INTO menu_items (category, name, description, emoji, display_order) VALUES
  ('hamburguesas', 'Pulled Pork Sándwich', 'Cerdo desmenuzado con BBQ y coleslaw', '🔥', 1),
  ('hamburguesas', 'Crispy Chicken Burger', 'Pollo crocante con mayo especial', '🍗', 2),
  ('hamburguesas', 'Clásica Breakpoint', 'Carne, lechuga, tomate y cheddar', '🥩', 3),
  ('hamburguesas', 'Doble Cheddar Smash', 'Doble medallon smash con cheddar', '🧀', 4),
  ('tragos', 'Berry Gin Tonic', 'Gin con frutos rojos y tonica', '🫐', 1),
  ('tragos', 'Limonada Nomade', 'Limonada con jengibre y menta', '🍋', 2),
  ('tragos', 'Mojito Clásico', 'Ron, menta, lima y soda', '🌿', 3),
  ('tragos', 'Aperol Spritz', 'Aperol, prosecco y soda', '🍊', 4),
  ('cervezas', 'Cerveza Nomade Tirada', 'Nuestra cerveza de la casa tirada', '🍻', 1),
  ('cervezas', 'Honey Blonde', 'Rubia suave con toque de miel', '🥂', 2),
  ('cervezas', 'IPA Artesanal', 'IPA con lúpulo americano', '🍺', 3),
  ('cervezas', 'Red Ale', 'Roja maltosa con caramelo', '🌾', 4),
  ('picadas', 'Tabla de Quesos', 'Selección de quesos con frutos secos', '🧀', 1),
  ('picadas', 'Papas con Cheddar', 'Papas fritas con salsa cheddar', '🍟', 2),
  ('picadas', 'Nachos Completos', 'Nachos con guacamole, cheddar y jalapeños', '🥓', 3),
  ('picadas', 'Empanadas del Día', 'Empanadas caseras variadas', '🫓', 4);

-- ============================================================
-- CONTENIDO INICIAL DEL SITIO
-- ============================================================

INSERT INTO site_content (id, content) VALUES
  ('hero_title', 'Breakpoint Pádel'),
  ('hero_subtitle', 'Viví la mejor experiencia de pádel en Córdoba. Canchas premium, torneos, clases y el mejor ambiente para tu tercer tiempo.'),
  ('about_title', 'Tu punto de encuentro para el mejor pádel'),
  ('about_text_1', 'Breakpoint Pádel nació con la misión de ofrecer la experiencia de pádel más completa de Córdoba. Canchas de primera, iluminación profesional y un ambiente que te hace querer volver.'),
  ('about_text_2', 'Con 3 sedes en zona sur, somos el club elegido por miles de jugadores que buscan calidad, comunidad y pasión por el deporte.'),
  ('whatsapp_number', '5493513247898'),
  ('instagram_handle', 'breakpoint.padel'),
  ('nomade_instagram', 'nomade_cba');

-- ============================================================
-- DATOS INICIALES - GALERÍA DE IMÁGENES
-- ============================================================
-- NOTA: Estas URLs usan rutas relativas que funcionan cuando
-- el sitio está hosteado. Si usás un dominio, reemplazá con URLs completas.

INSERT INTO gallery_images (url, storage_path, title, category, display_order) VALUES
  ('images/hero-bg.png', '', '🎾 Canchas en acción', 'canchas', 1),
  ('images/courts-view.png', '', '🏟️ Canchas premium', 'canchas', 2),
  ('images/bar-nomade.png', '', '🍺 Nomade Bar', 'bar', 3),
  ('images/padel-action.png', '', '💪 Acción pura', 'canchas', 4),
  ('images/club-exterior.png', '', '✨ Ambiente nocturno', 'exterior', 5),
  ('images/tournament-event.png', '', '🏆 Torneos', 'eventos', 6);

-- ============================================================
-- STORAGE BUCKET PARA IMÁGENES
-- ============================================================
-- NOTA: Crear manualmente en Supabase Dashboard > Storage:
-- 1. Crear bucket llamado "gallery" (público)
-- 2. En políticas del bucket, agregar:
--    - SELECT: público (anyone)
--    - INSERT/UPDATE/DELETE: solo authenticated

-- ============================================================
-- ¡LISTO! Ahora podés usar el panel admin.
-- ============================================================
