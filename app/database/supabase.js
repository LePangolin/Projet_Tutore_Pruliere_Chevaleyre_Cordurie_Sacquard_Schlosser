const { createClient } = require('@supabase/supabase-js');

const supabase = createClient("https://vxotsourytdmefkaqtzt.supabase.co","eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4b3Rzb3VyeXRkbWVma2FxdHp0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3NTM0NjU1OSwiZXhwIjoxOTkwOTIyNTU5fQ.H6Og0l_SRKSbmgn35VYLuM2RZWwt9mNRmUzeC6M-BLs");

module.exports = supabase;