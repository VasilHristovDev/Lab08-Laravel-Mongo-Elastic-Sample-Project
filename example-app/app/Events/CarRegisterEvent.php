<?php

namespace App\Events;

use App\Models\Mongo\Car;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CarRegisterEvent
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $car;
    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct(Car $car)
    {
        $car->staying = 1;
        $car->save();
        $this->car = $car;

    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('channel-name');
    }
}
