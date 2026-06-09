import { PrismaClient, EventStatus, Role, VerificationStatus } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting seed...');

  // ─── 1. Admin User ────────────────────────────────────────────────────────
  const adminHash = await bcrypt.hash('Admin@1234', 10);
  const admin = await prisma.user.upsert({
    where: { email: 'admin@bookmyevent.com' },
    update: {},
    create: {
      email: 'admin@bookmyevent.com',
      passwordHash: adminHash,
      firstName: 'Admin',
      lastName: 'User',
      phoneNumber: '+919999999999',
      role: Role.ADMIN,
    },
  });
  console.log('✅ Admin user created:', admin.email);

  // ─── 2. Organizer User ────────────────────────────────────────────────────
  const orgHash = await bcrypt.hash('Organizer@1234', 10);
  const orgUser = await prisma.user.upsert({
    where: { email: 'organizer@bookmyevent.com' },
    update: {},
    create: {
      email: 'organizer@bookmyevent.com',
      passwordHash: orgHash,
      firstName: 'Live',
      lastName: 'Nation',
      phoneNumber: '+919888888888',
      role: Role.ORGANIZER,
    },
  });

  const organizer = await prisma.organizer.upsert({
    where: { userId: orgUser.id },
    update: {},
    create: {
      userId: orgUser.id,
      name: 'LiveNation India',
      description: 'India\'s premier live event company',
      contactEmail: 'organizer@bookmyevent.com',
      contactPhone: '+919888888888',
      isVerified: true,
      verificationStatus: VerificationStatus.VERIFIED,
      verificationDate: new Date(),
    },
  });
  console.log('✅ Organizer created:', organizer.name);

  // ─── 3. Categories ────────────────────────────────────────────────────────
  const categoryData = [
    { name: 'Concerts',         slug: 'concerts',          iconUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=400&auto=format&fit=crop' },
    { name: 'Sports',           slug: 'sports',            iconUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?q=80&w=400&auto=format&fit=crop' },
    { name: 'Comedy',           slug: 'comedy',            iconUrl: 'https://images.unsplash.com/photo-1585699324551-f6c309eedeca?q=80&w=400&auto=format&fit=crop' },
    { name: 'Theatre',          slug: 'theatre',           iconUrl: 'https://images.unsplash.com/photo-1507676184212-d0330a15233c?q=80&w=400&auto=format&fit=crop' },
    { name: 'Festivals',        slug: 'festivals',         iconUrl: 'https://images.unsplash.com/photo-1533174000220-db9d1bd3db34?q=80&w=400&auto=format&fit=crop' },
    { name: 'Nightlife',        slug: 'nightlife',         iconUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=400&auto=format&fit=crop' },
    { name: 'Tech Events',      slug: 'tech-events',       iconUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?q=80&w=400&auto=format&fit=crop' },
    { name: 'Workshops',        slug: 'workshops',         iconUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?q=80&w=400&auto=format&fit=crop' },
    { name: 'Food Experiences', slug: 'food-experiences',  iconUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=400&auto=format&fit=crop' },
    { name: 'Art Exhibitions',  slug: 'art-exhibitions',   iconUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=400&auto=format&fit=crop' },
  ];

  const categories: Record<string, string> = {};
  for (const cat of categoryData) {
    const c = await prisma.category.upsert({
      where: { slug: cat.slug },
      update: { iconUrl: cat.iconUrl },
      create: cat,
    });
    categories[cat.name] = c.id;
  }
  console.log('✅ Categories seeded:', Object.keys(categories).length);

  // ─── 4. Venues ────────────────────────────────────────────────────────────
  const venueData = [
    { name: 'Jio World Garden',               address: 'BKC',                city: 'Mumbai',  state: 'Maharashtra', zipCode: '400051' },
    { name: 'DY Patil Stadium',               address: 'Nerul',              city: 'Navi Mumbai', state: 'Maharashtra', zipCode: '400706' },
    { name: 'Bandra Kurla Complex',           address: 'BKC',                city: 'Mumbai',  state: 'Maharashtra', zipCode: '400051' },
    { name: 'NCPA',                           address: 'Marine Lines',       city: 'Mumbai',  state: 'Maharashtra', zipCode: '400021' },
    { name: 'Bal Gandharva Rang Mandir',      address: 'FC Road',            city: 'Pune',    state: 'Maharashtra', zipCode: '411004' },
    { name: 'Wankhede Stadium',               address: 'D Rd, Churchgate',  city: 'Mumbai',  state: 'Maharashtra', zipCode: '400020' },
    { name: 'Mumbai Football Arena',          address: 'Andheri',            city: 'Mumbai',  state: 'Maharashtra', zipCode: '400053' },
    { name: 'Mahalaxmi Race Course',          address: 'Mahalaxmi',          city: 'Mumbai',  state: 'Maharashtra', zipCode: '400034' },
    { name: 'Vagator Beach',                  address: 'Vagator',            city: 'Goa',     state: 'Goa',         zipCode: '403509' },
    { name: 'Secret Location',               address: 'Lower Parel',        city: 'Mumbai',  state: 'Maharashtra', zipCode: '400013' },
    { name: 'Kitty Su',                      address: 'The Lalit Hotel',    city: 'Mumbai',  state: 'Maharashtra', zipCode: '400059' },
    { name: 'Nita Mukesh Ambani Cultural Centre', address: 'BKC',           city: 'Mumbai',  state: 'Maharashtra', zipCode: '400051' },
    { name: 'Jio World Convention Centre',   address: 'BKC',                city: 'Mumbai',  state: 'Maharashtra', zipCode: '400051' },
    { name: 'Bandra West Studio',            address: 'Bandra West',        city: 'Mumbai',  state: 'Maharashtra', zipCode: '400050' },
    { name: 'Colaba Garden',                 address: 'Colaba',              city: 'Mumbai',  state: 'Maharashtra', zipCode: '400005' },
    { name: 'The Botanist Bar',              address: 'Lower Parel',        city: 'Mumbai',  state: 'Maharashtra', zipCode: '400013' },
    { name: 'World Trade Centre',            address: 'Cuffe Parade',       city: 'Mumbai',  state: 'Maharashtra', zipCode: '400005' },
    { name: 'Kala Ghoda District',           address: 'Kala Ghoda',         city: 'Mumbai',  state: 'Maharashtra', zipCode: '400001' },
  ];

  const venueIds: string[] = [];
  for (const v of venueData) {
    const venue = await prisma.venue.create({ data: v }).catch(async () => {
      // May already exist if seeded before; just fetch by name+city
      return prisma.venue.findFirst({ where: { name: v.name, city: v.city } }) as any;
    });
    venueIds.push(venue!.id);
  }
  console.log('✅ Venues seeded:', venueIds.length);

  // Helper: get or create venue by index
  const getVenueId = (index: number) => venueIds[index % venueIds.length];

  // ─── 5. Events ───────────────────────────────────────────────────────────
  const now = new Date();
  const future = (days: number) => new Date(now.getTime() + days * 86400000);

  const eventsData = [
    // Concerts
    {
      title: 'Arijit Singh Live',
      slug: 'arijit-singh-live',
      description: 'Get ready for a soulful evening with Arijit Singh as he takes you on a musical journey of emotions and melodies.',
      category: 'Concerts', venue: 0, days: 45,
      heroImageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 1499,
    },
    {
      title: 'Coldplay – Music of the Spheres',
      slug: 'coldplay-music-of-spheres',
      description: 'Experience the ultimate music festival with Coldplay featuring stunning visuals and state-of-the-art sound systems.',
      category: 'Concerts', venue: 1, days: 90,
      heroImageUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 4999,
    },
    {
      title: 'Ed Sheeran – Mathematics Tour',
      slug: 'ed-sheeran-mathematics-tour',
      description: 'Catch Ed Sheeran live performing hits from his latest albums along with all-time classics.',
      category: 'Concerts', venue: 2, days: 120,
      heroImageUrl: 'https://images.unsplash.com/photo-1470229722913-7c092bb49ab4?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 3500,
    },
    // Comedy
    {
      title: 'Zakir Khan – Tathastu Live',
      slug: 'zakir-khan-tathastu',
      description: 'Join the Sakht Launda for an evening of relatable humor and incredible storytelling.',
      category: 'Comedy', venue: 3, days: 20,
      heroImageUrl: 'https://images.unsplash.com/photo-1585699324551-f6c309eedeca?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 999,
    },
    {
      title: 'Vir Das – Mind Fool Tour',
      slug: 'vir-das-mind-fool',
      description: 'International Emmy winner Vir Das brings his highly acclaimed Mind Fool tour.',
      category: 'Comedy', venue: 4, days: 30,
      heroImageUrl: 'https://images.unsplash.com/photo-1527224857830-43a7ebb8545e?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 1499,
    },
    // Sports
    {
      title: 'India vs Australia – Border-Gavaskar Trophy',
      slug: 'india-vs-australia-bgt',
      description: 'Witness the thrilling cricket match between India and Australia at the iconic Wankhede Stadium.',
      category: 'Sports', venue: 5, days: 12,
      heroImageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 1200,
    },
    {
      title: 'Mumbai City FC vs Mohun Bagan – ISL Final',
      slug: 'isl-final-mumbai-vs-mohun-bagan',
      description: 'The biggest clash in Indian football. Do not miss the ISL Final.',
      category: 'Sports', venue: 6, days: 25,
      heroImageUrl: 'https://images.unsplash.com/photo-1518605368461-1ee116035f49?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 500,
    },
    // Festivals
    {
      title: 'Lollapalooza India – Music & Arts Festival',
      slug: 'lollapalooza-india',
      description: 'Lollapalooza returns to India with a stellar lineup of global and local artists.',
      category: 'Festivals', venue: 7, days: 60,
      heroImageUrl: 'https://images.unsplash.com/photo-1533174000220-db9d1bd3db34?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 5999,
    },
    {
      title: 'Sunburn Goa – EDM Festival',
      slug: 'sunburn-goa-edm',
      description: 'The ultimate year-end party in Goa with the biggest DJs in the world.',
      category: 'Festivals', venue: 8, days: 50,
      heroImageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 3999,
    },
    // Nightlife
    {
      title: 'Boiler Room Mumbai Edition',
      slug: 'boiler-room-mumbai',
      description: 'An underground techno experience featuring top international and local selectors.',
      category: 'Nightlife', venue: 9, days: 8,
      heroImageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 2500,
    },
    {
      title: 'Neon Nights – Techno Party',
      slug: 'neon-nights-techno',
      description: 'Dance the night away with pulsating techno beats and glowing neon aesthetics.',
      category: 'Nightlife', venue: 10, days: 15,
      heroImageUrl: 'https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 1500,
    },
    // Theatre
    {
      title: 'Mughal-e-Azam – The Musical',
      slug: 'mughal-e-azam-musical',
      description: 'Experience the epic romance brought to life on stage with breathtaking costumes and live singing.',
      category: 'Theatre', venue: 11, days: 35,
      heroImageUrl: 'https://images.unsplash.com/photo-1507676184212-d0330a15233c?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 2500,
    },
    {
      title: 'Hamilton – International Tour',
      slug: 'hamilton-international-tour',
      description: 'The multi-award-winning musical masterpiece finally arrives in India.',
      category: 'Theatre', venue: 3, days: 100,
      heroImageUrl: 'https://images.unsplash.com/photo-1460723237483-7a6dc9d0b212?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 4500,
    },
    // Tech Events
    {
      title: 'AI Summit 2025 – Future of Tech',
      slug: 'ai-summit-2025',
      description: 'Join industry leaders to discuss the impact of AI on the future of humanity and business.',
      category: 'Tech Events', venue: 12, days: 40,
      heroImageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 5000,
    },
    // Workshops
    {
      title: 'Pottery Masterclass with Aditi Studio',
      slug: 'pottery-masterclass-aditi',
      description: 'A hands-on workshop to learn the art of wheel throwing and ceramic design.',
      category: 'Workshops', venue: 13, days: 10,
      heroImageUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 1200,
    },
    // Food Experiences
    {
      title: 'The Secret Supper Club – 7-Course Menu',
      slug: 'secret-supper-club',
      description: 'An exclusive dining experience focusing on modern Indian gastronomy.',
      category: 'Food Experiences', venue: 14, days: 18,
      heroImageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 4000,
    },
    {
      title: 'Gin Tasting Masterclass',
      slug: 'gin-tasting-masterclass',
      description: 'Explore the nuances of craft gins paired with artisanal tonics and garnishes.',
      category: 'Food Experiences', venue: 15, days: 22,
      heroImageUrl: 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?q=80&w=1000&auto=format&fit=crop',
      isFeatured: false, price: 2500,
    },
    // Art Exhibitions
    {
      title: 'Van Gogh 360° – Immersive Art',
      slug: 'van-gogh-360-immersive',
      description: 'Step into the paintings of Vincent Van Gogh in this mesmerizing 360-degree projection mapping exhibit.',
      category: 'Art Exhibitions', venue: 16, days: 5,
      heroImageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 999,
    },
    {
      title: 'Kala Ghoda Arts Festival',
      slug: 'kala-ghoda-arts-festival',
      description: "Asia's largest multi-cultural street festival featuring art installations, workshops, and performances.",
      category: 'Festivals', venue: 17, days: 75,
      heroImageUrl: 'https://images.unsplash.com/photo-1544531586-fde5298cdd40?q=80&w=1000&auto=format&fit=crop',
      isFeatured: true, price: 0,
    },
  ];

  let eventCount = 0;
  for (const e of eventsData) {
    const catId = categories[e.category];
    if (!catId) { console.warn(`⚠️ Category not found: ${e.category}`); continue; }

    const venueId = venueIds[e.venue];
    if (!venueId) { console.warn(`⚠️ Venue not found at index: ${e.venue}`); continue; }

    const start = future(e.days);
    const end   = new Date(start.getTime() + 3 * 3600000); // +3 hours

    try {
      const event = await prisma.event.upsert({
        where: { slug: e.slug },
        update: {},
        create: {
          title:        e.title,
          slug:         e.slug,
          description:  e.description,
          categoryId:   catId,
          venueId:      venueId,
          organizerId:  organizer.id,
          startTime:    start,
          endTime:      end,
          status:       EventStatus.PUBLISHED,
          heroImageUrl: e.heroImageUrl,
          isFeatured:   e.isFeatured,
          metrics: {
            create: {
              totalViews:    BigInt(Math.floor(Math.random() * 5000) + 200),
              totalBookings: Math.floor(Math.random() * 300),
              wishlistCount: Math.floor(Math.random() * 100),
              averageRating: parseFloat((Math.random() * 1 + 4).toFixed(2)),
            },
          },
          ticketTiers: {
            create: e.price > 0
              ? [
                  { name: 'General',  price: e.price,            availableQty: 500 },
                  { name: 'Premium',  price: e.price * 2,        availableQty: 100 },
                  { name: 'VIP',      price: e.price * 3.5,      availableQty: 30  },
                ]
              : [
                  { name: 'Free Entry', price: 0, availableQty: 1000 },
                ],
          },
        },
      });
      eventCount++;
      console.log(`  ✅ ${event.title}`);
    } catch (err: any) {
      console.warn(`  ⚠️ Skipped (already exists?): ${e.title} — ${err.message}`);
    }
  }

  console.log(`\n🎉 Seed complete! ${eventCount} events inserted into Neon.`);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
