-- ════════════════════════════════════════════════════════════
-- JOSEPHINE'S SCENTS — Supabase Database Setup
-- Run this ONCE in your Supabase SQL Editor
-- Dashboard → SQL Editor → New Query → paste this → Run
-- ════════════════════════════════════════════════════════════

-- ── PRODUCTS TABLE ────────────────────────────────────────────
create table if not exists products (
  id            integer primary key,
  name          text not null,
  em            text default '🌹',
  cat           text default 'Floral',
  price         integer not null,
  size          text default '50ml',
  notes         text default '',
  desc          text default '',
  brand         text default 'Josephine''s Scents',
  in_stock      boolean default true,
  is_new        boolean default false,
  image_url     text default '',
  rating        numeric default 5.0,
  rating_count  integer default 0,
  created_at    timestamptz default now()
);

-- ── ORDERS TABLE ─────────────────────────────────────────────
create table if not exists orders (
  id          text primary key,
  customer    text not null,
  phone       text default '',
  email       text default '',
  items       integer default 1,
  total       integer default 0,
  payment     text default '',
  status      text default 'pending',
  date        text default '',
  items_list  text default '',
  created_at  timestamptz default now()
);

-- ── REVIEWS TABLE ─────────────────────────────────────────────
create table if not exists reviews (
  id          bigint generated always as identity primary key,
  product_id  integer references products(id) on delete cascade,
  reviewer    text default 'Anonymous',
  stars       integer default 5,
  review_text text default '',
  created_at  timestamptz default now()
);

-- ── ROW LEVEL SECURITY (RLS) ─────────────────────────────────
-- Allow anyone to READ products and reviews (public shop)
alter table products enable row level security;
alter table orders   enable row level security;
alter table reviews  enable row level security;

-- Products: public read, anyone can write (owner controls via password)
create policy "Public read products"
  on products for select using (true);

create policy "Anyone can upsert products"
  on products for insert with check (true);

create policy "Anyone can update products"
  on products for update using (true);

create policy "Anyone can delete products"
  on products for delete using (true);

-- Orders: anyone can insert (place order), anyone can read & update (owner dashboard)
create policy "Anyone can insert orders"
  on orders for insert with check (true);

create policy "Anyone can read orders"
  on orders for select using (true);

create policy "Anyone can update orders"
  on orders for update using (true);

-- Reviews: public read and insert
create policy "Public read reviews"
  on reviews for select using (true);

create policy "Anyone can insert reviews"
  on reviews for insert with check (true);

-- ── SEED DEFAULT PRODUCTS ─────────────────────────────────────
-- This loads the 12 built-in fragrances into Supabase.
-- After running, any products she adds from the dashboard
-- will also appear here automatically.

insert into products (id, name, em, cat, price, size, notes, desc, brand, in_stock, is_new, rating, rating_count) values
(1,  'Oud Royale',     '🪵', 'Oud',      12500, '50ml', 'Deep oud · Amber · Sandalwood',     'A majestic oud blend inspired by the royal courts of the East. Rich, smoky, and enduring.',                    'Josephine''s Scents', true,  false, 4.8, 24),
(2,  'Rose Céleste',   '🌹', 'Floral',    9800, '50ml', 'Damask rose · Musk · Bergamot',     'Velvety rose petals kissed by morning dew. A timeless floral with a thoroughly modern soul.',                 'Josephine''s Scents', true,  true,  4.9, 38),
(3,  'Citrus Soleil',  '🍊', 'Fresh',     7500, '30ml', 'Blood orange · Grapefruit · Vetiver','A burst of Mediterranean sunshine. Light, vibrant, and perfect for every occasion.',                          'Josephine''s Scents', true,  false, 4.6, 17),
(4,  'Black Velvet',   '🖤', 'Oriental', 15000, '100ml','Black pepper · Iris · Tonka bean',  'Mysterious and captivating. This bold oriental commands every room it enters with quiet authority.',           'Josephine''s Scents', false, false, 4.7, 12),
(5,  'Jasmine Dreams', '🌸', 'Floral',    8900, '50ml', 'Jasmine · Ylang-ylang · Vanilla',   'Dreamy and intoxicating — the scent of warm summer nights beneath a canopy of stars.',                        'Josephine''s Scents', true,  true,  4.8, 29),
(6,  'Cedar & Smoke',  '🌲', 'Woody',    11200, '50ml', 'Cedarwood · Smoked oak · Leather',  'Raw, earthy power. A fragrance designed for those who walk their own path without apology.',                   'Josephine''s Scents', true,  false, 4.5, 10),
(7,  'La Mer Blanche', '🌊', 'Fresh',     8200, '30ml', 'Sea salt · White tea · Driftwood',  'The crisp, clean breath of the open ocean. Pure, free, and completely calming.',                               'Josephine''s Scents', true,  false, 4.6, 15),
(8,  'Saffron Elixir', '✨', 'Oriental', 13800, '50ml', 'Saffron · Rose · Patchouli',        'A luxurious saffron heart enveloped in rose and patchouli. Opulent, exotic, unforgettable.',                   'Josephine''s Scents', false, false, 4.9,  8),
(9,  'Neroli Garden',  '🌼', 'Floral',    8600, '30ml', 'Neroli · White peach · Musk',       'Delicate neroli blossoms rising above a peachy, musky base. The essence of pure elegance.',                    'Josephine''s Scents', true,  false, 4.7, 21),
(10, 'Oud Noir',       '🌑', 'Oud',      18000, '100ml','Black oud · Frankincense · Myrrh',  'The darkest chapter of oud perfumery. Dense, sacred, and profoundly unforgettable.',                          'Josephine''s Scents', true,  true,  4.9, 33),
(11, 'Ambre Doux',     '🍯', 'Oriental', 10500, '50ml', 'Warm amber · Honey · Vanilla',      'Amber kissed with honey and warm vanilla — cocooning, sweet, and deeply irresistible.',                       'Josephine''s Scents', true,  false, 4.6, 19),
(12, 'Iris Blanc',     '🤍', 'Floral',    9200, '50ml', 'White iris · Powder · Cedarwood',   'Powdery iris with a clean wooden base. Understated luxury at its finest.',                                    'Josephine''s Scents', true,  true,  4.8, 14)
on conflict (id) do nothing;
