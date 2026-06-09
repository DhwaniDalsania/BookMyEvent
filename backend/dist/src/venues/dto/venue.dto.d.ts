export declare class CreateVenueDto {
    name: string;
    address: string;
    city: string;
    state: string;
    zipCode: string;
    latitude?: number;
    longitude?: number;
    googleMapsUrl?: string;
}
export declare class UpdateVenueDto {
    name?: string;
    address?: string;
    city?: string;
    state?: string;
    zipCode?: string;
    latitude?: number;
    longitude?: number;
    googleMapsUrl?: string;
}
