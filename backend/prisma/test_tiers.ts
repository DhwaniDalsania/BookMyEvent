import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('Querying events with ticket tiers...');
  const events = await prisma.event.findMany({
    include: {
      ticketTiers: true,
    },
    take: 3,
  });

  for (const event of events) {
    console.log(`Event: ${event.title}`);
    console.log('Ticket Tiers:', event.ticketTiers);
  }
}

main().catch(console.error).finally(() => prisma.$disconnect());
