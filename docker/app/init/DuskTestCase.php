<?php

namespace Tests;

use Laravel\Dusk\TestCase as BaseTestCase;
use Facebook\WebDriver\Chrome\ChromeOptions;
use Facebook\WebDriver\Remote\RemoteWebDriver;
use Facebook\WebDriver\Remote\DesiredCapabilities;
use Illuminate\Support\Facades\Artisan;

abstract class DuskTestCase extends BaseTestCase
{
    use CreatesApplication;

    private $dusk_env = '.env.dusk.local';

    public function setUp(): void
    {
        parent::setUp();
        $this->app = $this->createApplication();
        if (file_exists($this->app->basePath($this->dusk_env))) {
            $this->app->loadEnvironmentFrom($this->dusk_env);
            Artisan::call('config:cache');
        }
    }

    public function tearDown(): void
    {
        Artisan::call('config:clear');
        parent::tearDown();
    }

    /**
     * Prepare for Dusk test execution.
     *
     * @beforeClass
     * @return void
     */
    public static function prepare()
    {
        static::startChromeDriver();
    }

    /**
     * Create the RemoteWebDriver instance.
     *
     * @return \Facebook\WebDriver\Remote\RemoteWebDriver
     */
    protected function driver()
    {
        $options = (new ChromeOptions)->addArguments([
            '--disable-gpu',
            '--headless',
            '--no-sandbox'
        ]);

        return RemoteWebDriver::create(
            'http://localhost:9515',
            DesiredCapabilities::chrome()
                ->setCapability(
                    ChromeOptions::CAPABILITY,
                    $options
                )
        );

    }
}
