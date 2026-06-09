"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
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
//# sourceMappingURL=test_tiers.js.map