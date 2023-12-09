<?php

namespace App\Models\Mongo;

class Truck extends Vehicle
{
    const NEEDED_SLOTS = 4;
    const CATEGORY = "C";
    const PRICE_DAY = 12;
    const PRICE_NIGHT = 6;

    protected $collection = 'cars';

    private readonly string $category;

    public function __construct(array $attributes = [])
    {
        parent::__construct($attributes);
        $this->registrationPlate = $attributes['registrationPlate'];
        $this->brand = $attributes['brand'];
        $this->model = $attributes['model'];
        $this->color = $attributes['color'];
        $this->category = self::CATEGORY;
    }

    public function getNeededSlots(): int
    {
        return self::NEEDED_SLOTS;
    }

    public function getPrices(): array
    {
        return [
          'day' => self::PRICE_DAY,
          'night' => self::PRICE_NIGHT,
        ];
    }
}
