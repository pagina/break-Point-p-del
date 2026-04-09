-- ============================================================
-- FIX: Error "new row violates row-level security policy"
-- al subir imágenes a la galería de Breakpoint Pádel
-- ============================================================
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- ============================================================

-- PASO 1: Borrar la política vieja que no funciona para INSERT
DROP POLICY IF EXISTS "gallery_admin_all" ON gallery_images;

-- PASO 2: Crear políticas separadas por operación
-- SELECT: cualquiera puede ver (ya existe, pero la recreamos por si acaso)
DROP POLICY IF EXISTS "gallery_public_read" ON gallery_images;
CREATE POLICY "gallery_public_read" ON gallery_images
  FOR SELECT USING (true);

-- INSERT: usuarios autenticados pueden insertar
CREATE POLICY "gallery_admin_insert" ON gallery_images
  FOR INSERT TO authenticated WITH CHECK (true);

-- UPDATE: usuarios autenticados pueden editar
CREATE POLICY "gallery_admin_update" ON gallery_images
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

-- DELETE: usuarios autenticados pueden borrar
CREATE POLICY "gallery_admin_delete" ON gallery_images
  FOR DELETE TO authenticated USING (true);

-- ============================================================
-- PASO 3: Arreglar las políticas de STORAGE (bucket "gallery")
-- ============================================================
-- IMPORTANTE: Esto configura las políticas del bucket de storage.
-- Si el bucket ya existe, esto arregla los permisos.

-- Permitir a cualquiera VER archivos del bucket gallery
DROP POLICY IF EXISTS "gallery_storage_read" ON storage.objects;
CREATE POLICY "gallery_storage_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'gallery');

-- Permitir a usuarios autenticados SUBIR archivos
DROP POLICY IF EXISTS "gallery_storage_insert" ON storage.objects;
CREATE POLICY "gallery_storage_insert" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'gallery');

-- Permitir a usuarios autenticados ACTUALIZAR archivos
DROP POLICY IF EXISTS "gallery_storage_update" ON storage.objects;
CREATE POLICY "gallery_storage_update" ON storage.objects
  FOR UPDATE TO authenticated USING (bucket_id = 'gallery') WITH CHECK (bucket_id = 'gallery');

-- Permitir a usuarios autenticados ELIMINAR archivos
DROP POLICY IF EXISTS "gallery_storage_delete" ON storage.objects;
CREATE POLICY "gallery_storage_delete" ON storage.objects
  FOR DELETE TO authenticated USING (bucket_id = 'gallery');

-- ============================================================
-- ¡LISTO! Ahora podés subir imágenes desde el panel admin.
-- ============================================================
