<?php

namespace Tests;

use Laravel\Dusk\TestCase as BaseTestCase;
use Facebook\WebDriver\Chrome\ChromeOptions;
use Facebook\WebDriver\Remote\RemoteWebDriver;
use Facebook\WebDriver\Remote\DesiredCapabilities;
use Illuminate\Support\Facades\Artisan;

/**
 * Class DuskTestCase
 *
 * @package Tests
 */
abstract class DuskTestCase extends BaseTestCase
{
    use CreatesApplication;

    /** @var string */
    private $duskEnv = '.env.dusk.local';

    /**
     * @return void
     */
    public function setUp(): void
    {
        parent::setUp();
        $this->app = $this->createApplication();
        if (file_exists($this->app->basePath($this->duskEnv))) {
            $this->app->loadEnvironmentFrom($this->duskEnv);
            Artisan::call('config:cache');
        }
    }

    /**
     * @return void
     */
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
        $options = (new ChromeOptions())->addArguments([
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
