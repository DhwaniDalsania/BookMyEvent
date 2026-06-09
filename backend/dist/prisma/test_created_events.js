"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
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
//# sourceMappingURL=test_created_events.js.map