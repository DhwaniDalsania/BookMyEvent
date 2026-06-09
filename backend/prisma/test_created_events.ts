import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('Querying newly created events by organizers...');
  const events = await prisma.event.findMany({
    include: {
      ticketTiers: true,
    },
    orderBy: {
      createdAt: 'desc',
    },
    take: 5,
  });

  for (const event of events) {
    console.log(`Event: ${event.title}, CreatedAt: ${event.createdAt}`);
    console.log('Ticket Tiers:', event.ticketTiers);
  }
}

main().catch(console.error).finally(() => prisma.$disconnect());
