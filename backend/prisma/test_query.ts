import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const events = await prisma.event.findMany({
    where: {
      title: 'rahul ji'
    },
    include: {
      ticketTiers: true,
    }
  });

  if (events.length > 0) {
    const event = events[0];
    console.log('Event Name:', event.title);
    console.log('Raw ticketTiers:', event.ticketTiers);
    console.log('JSON serialized ticketTiers:', JSON.stringify(event.ticketTiers));
  } else {
    console.log('No event found with title "rahul ji"');
  }
}

main().catch(console.error).finally(() => prisma.$disconnect());
