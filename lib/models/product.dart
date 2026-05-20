class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final String category; // 'Construction', 'Sunglasses', 'Eyeglasses', 'Blue Light'
  final List<String> specs;
  final List<String> features;
  final String frameMaterial;
  final String lensType;
  final String weight;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.specs,
    required this.features,
    required this.frameMaterial,
    required this.lensType,
    required this.weight,
    required this.stock,
  });
}

// Beautiful product catalog data
final List<Product> sampleProducts = [
  // CATEGORY: Construction & Safety Glasses
  const Product(
    id: 'c1',
    name: 'IronClad Z87 Pro',
    description: 'Heavy-duty professional grade safety glasses designed for extreme work environments. Fully certified for ballistic impact resistance with wrap-around side shields to protect from debris.',
    price: 34.99,
    imageUrl: 'https://images.unsplash.com/photo-1598257006458-087169a1f08d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Safety goggles
    rating: 4.8,
    reviewsCount: 142,
    category: 'Construction',
    specs: [
      'ANSI Z87.1+ Certified',
      'MIL-PRF-32432 Ballistic Rated',
      '99.9% UVA/UVB/UVC Protection',
      'Anti-Fog Hydrophobic Coating'
    ],
    features: [
      'Shatterproof polycarbonate lens',
      'Scratch-resistant dual-coat',
      'Adjustable non-slip rubber temples',
      'Detachable dust-guard seal'
    ],
    frameMaterial: 'Reinforced TR90 Polymer',
    lensType: 'Clear Impact-Resistant Polycarbonate',
    weight: '32g',
    stock: 75,
  ),
  const Product(
    id: 'c2',
    name: 'Sentinel Anti-Glare Shield',
    description: 'Specialized safety glasses with amber-tinted lenses, optimized for outdoor construction site visibility, concrete work, and low-light or overcast conditions.',
    price: 38.50,
    imageUrl: 'https://images.unsplash.com/photo-1591076482161-42ce6da69f67?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Amber safety glasses/goggles style
    rating: 4.7,
    reviewsCount: 89,
    category: 'Construction',
    specs: [
      'ANSI Z87.1-2020 Standard',
      'EN166 F Certified',
      'High-Contrast Amber Tint',
      'Anti-Scratch ToughCoat'
    ],
    features: [
      'Enhanced depth perception',
      'Ultra-lightweight sleek frame',
      'Flexible soft-nose bridge',
      'Perforated temples for airflow'
    ],
    frameMaterial: 'Ultra-Flex Nylon-12',
    lensType: 'Amber Anti-Glare Polycarbonate',
    weight: '28g',
    stock: 42,
  ),
  const Product(
    id: 'c3',
    name: 'Titan Over-Specs Goggles',
    description: 'Designed to fit comfortably over prescription eyewear. Provides full top, bottom, and side shield protection without visual distortion. Ideal for heavy carpentry, welding prep, and dust-heavy sites.',
    price: 24.95,
    imageUrl: 'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Safety goggles
    rating: 4.6,
    reviewsCount: 115,
    category: 'Construction',
    specs: [
      'ANSI Z87.1 High-Impact Rated',
      'CSA Z94.3 Approved',
      'Fits over frames up to 145mm wide',
      'Full 180° Panoramic Field'
    ],
    features: [
      'Direct ventilation system',
      'Wide adjustable elastic strap',
      'Ultra-soft face sealing gasket',
      'Fits over prescription glasses'
    ],
    frameMaterial: 'Soft PVC / Polycarbonate',
    lensType: 'Double-Sided Anti-Fog Clear',
    weight: '45g',
    stock: 120,
  ),
  const Product(
    id: 'c4',
    name: 'SentrySafe Laminated Pro',
    description: 'Ultra high-performance safety glasses featuring specialized multi-layered laminated safety glass. Perfect for industrial glass cutting, heavy masonry, and extreme debris protection. Holds together upon high impact to completely prevent fragment-related optical injuries.',
    price: 49.99,
    imageUrl: 'https://images.unsplash.com/photo-1581092921461-eab62e97a780?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // High-tech engineer/safety glasses visual
    rating: 4.9,
    reviewsCount: 176,
    category: 'Construction',
    specs: [
      'ANSI Z87.1+ Laminated',
      'Laminated ShatterGuard Lenses',
      '99.9% UV-A/B Protection',
      'Anti-Scratch HardCoat'
    ],
    features: [
      'Laminated glass multi-layer technology',
      'Anti-splinter cohesive bonding matrix',
      'High-impact composite brow guard',
      'Soft flexible hypoallergenic nosepads'
    ],
    frameMaterial: 'Carbon-Reinforced Matrix',
    lensType: 'Clear Laminated Safety Glass',
    weight: '36g',
    stock: 65,
  ),


  // CATEGORY: Fashion & Sunglasses
  const Product(
    id: 's1',
    name: 'Aero Titanium Aviator',
    description: 'Timeless luxury meets featherweight materials. Handcrafted from aerospace-grade titanium, these aviators offer double bridge detailing and premium Japanese polarized lenses for perfect glare elimination.',
    price: 189.99,
    imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Sunglasses aviator
    rating: 4.9,
    reviewsCount: 204,
    category: 'Sunglasses',
    specs: [
      'UV400 100% Protection',
      'Premium Japanese Polarization',
      'Anti-Reflective Back-Coating',
      'Oleophobic Fingerprint-Resistant'
    ],
    features: [
      'Aerospace pure titanium temples',
      'Custom organic silicone nosepads',
      'Hand-polished gold metallic finish',
      'Reinforced 5-barrel hinges'
    ],
    frameMaterial: 'Beta-Titanium',
    lensType: 'Smoke Polarized Tri-Acetate Cellulose (TAC)',
    weight: '14g',
    stock: 18,
  ),
  const Product(
    id: 's2',
    name: 'Urban Obsidian Square',
    description: 'Bold, modern sunglasses crafted from biodegradable Italian acetate. With robust solid lines and dark green lenses, it delivers an iconic look that matches casual street styles perfectly.',
    price: 125.00,
    imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Retro square sunglasses
    rating: 4.5,
    reviewsCount: 76,
    category: 'Sunglasses',
    specs: [
      'UV400 High Protection',
      'Category 3 Sun Filter Rating',
      'Solid Green G-15 Lenses',
      'Hand-assembled in Milan'
    ],
    features: [
      'Premium Mazzucchelli acetate frame',
      'Wire-core reinforced temples',
      'High-gloss black lacquer finish',
      'Scratch-resistant CR-39 lenses'
    ],
    frameMaterial: 'Italian Bio-Acetate',
    lensType: 'Solid Dark Green CR-39',
    weight: '24g',
    stock: 35,
  ),

  // CATEGORY: Prescription Eyeglasses
  const Product(
    id: 'e1',
    name: 'Cambridge Round Classic',
    description: 'Charming vintage aesthetic, built with contemporary durability. Features round acetate rims bonded with surgical steel wire frame elements. Perfect for office and intellectual looks.',
    price: 85.00,
    imageUrl: 'https://images.unsplash.com/photo-1577803645773-f96470509666?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Eyeglasses
    rating: 4.7,
    reviewsCount: 92,
    category: 'Eyeglasses',
    specs: [
      'Prescription-Ready (Rx-able)',
      'Multi-Coat Anti-Reflective Included',
      'Surgical Stainless Steel Core',
      'Adjustable Ceramic Nosepads'
    ],
    features: [
      'Retro-modern hybrid construction',
      'Super lightweight for all-day wear',
      'Satin gold and tortoiseshell finish',
      'Spring hinges for adaptive fit'
    ],
    frameMaterial: 'Stainless Steel & Acetate',
    lensType: 'Clear Demo Lens (Ready for Prescription)',
    weight: '18g',
    stock: 50,
  ),
  const Product(
    id: 'e2',
    name: 'Metro Tech Rectangle',
    description: 'Sleek, minimalist and engineered for performance. A semi-rimless rectangular design that offers an unobstructed view and an extremely professional, clean corporate appearance.',
    price: 99.00,
    imageUrl: 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Sleek glasses
    rating: 4.6,
    reviewsCount: 63,
    category: 'Eyeglasses',
    specs: [
      'Prescription-Ready (Rx-able)',
      'Semi-Rimless Design',
      'Spring Hinge Architecture',
      'Dual-Color Matte Finish'
    ],
    features: [
      'Ultra-thin flexible metal temples',
      'Hypoallergenic silicone ear grips',
      'Corrosion-resistant metal plating',
      'Highly flexible frame bridge'
    ],
    frameMaterial: 'Monel Metal Alloy',
    lensType: 'Clear Demo Lens (Ready for Prescription)',
    weight: '16g',
    stock: 30,
  ),

  // CATEGORY: Gaming & Blue Light
  const Product(
    id: 'b1',
    name: 'Optix Blue-Shield Guardian',
    description: 'Engineered specifically for developers, gamers, and writers who spend hours looking at digital screens. Deflects harmful blue-violet light rays, dramatically reducing dry eyes and mental fatigue.',
    price: 49.99,
    imageUrl: 'https://images.unsplash.com/photo-1509695507497-903c140c43b0?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3', // Smart blue light style
    rating: 4.8,
    reviewsCount: 310,
    category: 'Blue Light',
    specs: [
      'Blocks 45% of High-Energy Blue Light',
      'Blocks 99% of UV Rays',
      'Anti-Reflective (AR) Double Coating',
      'Zero-Power Plane Lenses'
    ],
    features: [
      'Slight amber tint for natural contrast',
      'Flexible injection-molded frame',
      'Ultra-comfortable wide saddle bridge',
      'Durable metallic rivet hinges'
    ],
    frameMaterial: 'TR90 Swiss Thermoplastic',
    lensType: 'Blue-Shield Acrylic Plane Lens',
    weight: '17g',
    stock: 95,
  ),
];
