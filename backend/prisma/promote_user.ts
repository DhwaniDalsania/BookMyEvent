import { PrismaClient, Role, VerificationStatus } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const email = process.argv[2];
  if (!email) {
    console.error('❌ Please provide the email address of the user to promote.');
    console.error('Usage: npx ts-node prisma/promote_user.ts <email>');
    process.exit(1);
  }

  console.log(`Connecting to database to promote user: ${email}...`);

  const user = await prisma.user.findUnique({
    where: { email },
  });

  if (!user) {
    console.error(`❌ User with email "${email}" not found.`);
    process.exit(1);
  }

  if (user.role === Role.ORGANIZER || user.role === Role.ADMIN) {
    console.log(`ℹ️ User already has role: ${user.role}`);
  } else {
    // 1. Update User Role
    await prisma.user.update({
      where: { id: user.id },
      data: { role: Role.ORGANIZER },
    });
    console.log(`✅ User role updated to ORGANIZER`);
  }

  // 2. Create Organizer profile if it doesn't exist
  const existingOrganizer = await prisma.organizer.findUnique({
    where: { userId: user.id },
  });

  if (!existingOrganizer) {
    const org = await prisma.organizer.create({
      data: {
        userId: user.id,
        name: `${user.firstName} ${user.lastName} Productions`,
        contactEmail: user.email,
        contactPhone: user.phoneNumber,
        isVerified: true,
        verificationStatus: VerificationStatus.VERIFIED,
        verificationDate: new Date(),
      },
    });
    console.log(`✅ Created Organizer profile: "${org.name}"`);
  } else {
    console.log(`ℹ️ Organizer profile already exists: "${existingOrganizer.name}"`);
  }

  console.log('🎉 Done! The user can now log in and access the Organizer Dashboard.');
}

main()
  .catch((e) => {
    console.error('❌ Promotion failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
