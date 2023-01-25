<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class RegisterTest extends TestCase
{
    use RefreshDatabase;

    /**
     *
     * @test
     *
     * @return void
     */
    public function user_can_register()
    {
        $response = $this->post(route('register'), [
            'name' => 'Test Tester',
            'email' => 'tester@web.de',
            'password' => 'password',
            'password_confirmation' => 'password'
        ]);

        $response->assertSessionHasNoErrors();

        //User::where('email', 'tester@web.de')->count();
    }
}
