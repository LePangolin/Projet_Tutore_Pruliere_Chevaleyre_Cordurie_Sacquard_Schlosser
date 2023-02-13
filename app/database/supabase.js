const { createClient } = require('@supabase/supabase-js');

const supabase = createClient("https://vxotsourytdmefkaqtzt.supabase.co","eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4b3Rzb3VyeXRkbWVma2FxdHp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzUzNDY1NTksImV4cCI6MTk5MDkyMjU1OX0.k4lhfg44kv81zRiEkjOXJe9XATUDD7kz1Uwyl9w01dM");

module.exports = supabase;