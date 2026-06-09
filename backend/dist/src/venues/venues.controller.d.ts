import { VenuesService } from './venues.service';
import { CreateVenueDto, UpdateVenueDto } from './dto/venue.dto';
export declare class VenuesController {
    private readonly venuesService;
    constructor(venuesService: VenuesService);
    create(createVenueDto: CreateVenueDto): import("@prisma/client").Prisma.Prisma__VenueClient<{
        id: string;
        createdAt: Date;
        name: string;
        address: string;
        city: string;
        state: string;
        zipCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal | null;
        longitude: import("@prisma/client/runtime/library").Decimal | null;
        googleMapsUrl: string | null;
        placeId: string | null;
    }, never, import("@prisma/client/runtime/library").DefaultArgs, import("@prisma/client").Prisma.PrismaClientOptions>;
    findAll(): import("@prisma/client").Prisma.PrismaPromise<{
        id: string;
        createdAt: Date;
        name: string;
        address: string;
        city: string;
        state: string;
        zipCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal | null;
        longitude: import("@prisma/client/runtime/library").Decimal | null;
        googleMapsUrl: string | null;
        placeId: string | null;
    }[]>;
    findOne(id: string): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        address: string;
        city: string;
        state: string;
        zipCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal | null;
        longitude: import("@prisma/client/runtime/library").Decimal | null;
        googleMapsUrl: string | null;
        placeId: string | null;
    }>;
    update(id: string, updateVenueDto: UpdateVenueDto): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        address: string;
        city: string;
        state: string;
        zipCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal | null;
        longitude: import("@prisma/client/runtime/library").Decimal | null;
        googleMapsUrl: string | null;
        placeId: string | null;
    }>;
    remove(id: string): Promise<{
        id: string;
        createdAt: Date;
        name: string;
        address: string;
        city: string;
        state: string;
        zipCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal | null;
        longitude: import("@prisma/client/runtime/library").Decimal | null;
        googleMapsUrl: string | null;
        placeId: string | null;
    }>;
}
