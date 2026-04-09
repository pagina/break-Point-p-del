-- ============================================================
-- MEJORA 1: Agregar columna "cancha" a la tabla reservas
-- ============================================================
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- ============================================================

-- Agregar columna cancha (text) a reservas si no existe
ALTER TABLE reservas ADD COLUMN IF NOT EXISTS cancha TEXT DEFAULT '';
