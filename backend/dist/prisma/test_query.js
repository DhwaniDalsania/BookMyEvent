"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const payments = await prisma.payment.findMany({
        orderBy: { createdAt: 'desc' },
        take: 5,
        include: {
            booking: true,
        }
    });
    console.log('Recent Payments:', JSON.stringify(payments, null, 2));
}
main().catch(console.error).finally(() => prisma.$disconnect());
//# sourceMappingURL=test_query.js.map