<?php
namespace SXF\Web\Controllers;

use SXF\Config\Config;
use SXF\XML\SimpleXML;
use XSLTProcessor;

use Symfony\Component\HttpKernel\HttpKernelInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Matcher\UrlMatcher;
use Symfony\Component\Routing\RequestContext;
use Symfony\Component\Routing\RouteCollection;
use Symfony\Component\Routing\Exception\ResourceNotFoundException;
use Symfony\Component\Routing\Exception\MethodNotAllowedException;


use DebugBar\StandardDebugBar;
use DebugBar\DataCollector;

use SXF\GeoIp\GeoIp;
use SXF\Helper\Time;

class WebController implements HttpKernelInterface
{
    /**
     * @var bool
     */
    public $debug = false;

    /**
     * @var bool
     */
    public $isLoggedIn = false;

    /** @var RouteCollection */
    protected $routes;

    /**
     * @var Config
     */
    public $configuration;

    /**
     * @var bool
     */
    private static $debugXML;

    /**
     * @var string
     */
    protected static $requestedController;

    /**
     * @var string
     */
    protected static $requestedFunction;

    /**
     * @var string
     */
    public static $xslTemplateFile;

    /**
     * @var SimpleXML
     */
    public $xmlDataSXF;

    /**
     * @var SimpleXML
     */
    public $xmlDataController;

    /**
     * @var Request
     */
    public $request;

    /**
     * WebController constructor.
     * @param $routing
     * @param Config $configuration
     */
    public function __construct($routing, Config $configuration)
    {
        $this->configuration = $configuration;

        $this->routes = $routing;

        $this->debug = 'true' == $this->configuration->get('app.debug') ? true : false;
    }

    /**
     * @param Request $request
     * @param int $type
     * @param bool $catch
     * @return Response
     * @throws \Error
     * @throws \MaxMind\Db\Reader\InvalidDatabaseException
     * @throws \Raven_Exception
     */
    public function handle(Request $request, $type = HttpKernelInterface::MASTER_REQUEST, $catch = true)
    {
        $this->request = $request;

        $this->xmlDataSXF = new SimpleXML('<xml/>');

        $context = new RequestContext();
        $context->fromRequest($this->request);

        try {

            // match request
            $matcher = new UrlMatcher($this->routes, $context);

            // get controller from route
            list(self::$requestedController, self::$requestedFunction) = explode(
                '::',
                $matcher->match($this->request->getPathInfo())['_controller']
            );

            // check if we should generate XML and transform it via XSLT processor
            $view = $matcher->match($this->request->getPathInfo())['view'];

            // only when route is set to view template
            if (true == $view)
            {
                $this->generateXML($view);
            }

            // controller instance
            call_user_func_array(
                [new self::$requestedController($this), self::$requestedFunction],
                [$matcher->match($this->request->getPathInfo())]
            );

            if (true == $this->debug) {
                $this->generateDebug();
            }

            $response = new Response($this->xsltTransform($view),Response::HTTP_OK);

        } catch (ResourceNotFoundException $exception) { // 404

            // TODO: jakos zalogowac jesli nie devel wlacznie z refererem

            self::$xslTemplateFile = $this->configuration->get('app.paths.views') . 'errors/404.xsl';
            $response = new Response($this->xsltTransform(true), Response::HTTP_NOT_FOUND);

        } catch (MethodNotAllowedException $exception) { // 405

            // TODO: jakos zalogowac jesli nie devel

            self::$xslTemplateFile = $this->configuration->get('app.paths.views') . 'errors/405.xsl';
            $response = new Response($this->xsltTransform(true), Response::HTTP_METHOD_NOT_ALLOWED);

        } catch (\Error $exception) {

            if ($this->debug == true) {

                throw new \Error($exception);

            } else {

                $client = (new \Raven_Client($this->configuration->get('app.sentry.dsn')))->install();
                $client->captureException($exception);

//                $error_handler = new \Raven_ErrorHandler($client);
//                $error_handler->registerExceptionHandler();
//                $error_handler->registerErrorHandler();
//                $error_handler->registerShutdownFunction();

                self::$xslTemplateFile = $this->configuration->get('app.paths.views') . 'errors/500.xsl';
            }

            $response = new Response($this->xsltTransform(true), Response::HTTP_INTERNAL_SERVER_ERROR);
        }

        return $response;
    }

    /**
     * @param bool $xsltProcessor
     * @throws \MaxMind\Db\Reader\InvalidDatabaseException
     */
    private function generateXML(bool $xsltProcessor)
    {
        if (true === $xsltProcessor) {
            // xml
            $xmlData = [
                'debug' => $this->debug,
                'session_id' => session_id(), // TODO: moze brac pozniej z symfony https://symfony.com/doc/current/components/http_foundation/sessions.html
                'baseUrl' => $this->request->getSchemeAndHttpHost() . '/',
                'uri' => $this->request->getUri(),
                'httpHost' => $this->request->getHttpHost(),
                'isSecure' => $this->request->isSecure(),
            ];

            // data
            $this->xmlDataSXF->addArrayData($xmlData, 'data', true);

            // time
            $this->xmlDataSXF->addArrayData(Time::getTimeData(), 'time', true);

            // geo
            $geoData = new GeoIp($this->configuration->get('maxmind.database_file'));

            $this->xmlDataSXF->addArrayData(
                $geoData->getGeoIpData($this->request->getClientIp()),
                'geo', true
            );

            // controller
            $this->xmlDataController = $this->xmlDataSXF->addChild('controller');
            $this->xmlDataController->addAttribute('name', self::$requestedController);
            $this->xmlDataController->addAttribute('function', self::$requestedFunction);
        }

        return;
    }

    /**
     * @param bool $transform
     * @return string
     */
    private function xsltTransform(bool $transform)
    {
        $out = null;
        if (!empty(self::$xslTemplateFile) && true === $transform) {
            $xslt = new XSLTProcessor();

            $xslt->importStyleSheet(simplexml_load_file(self::$xslTemplateFile));

            $xslt->registerPHPFunctions();

            $out = $xslt->transformToXML($this->xmlDataSXF);
        }

        return $out;
    }

    /**
     *
     */
    private function generateDebug()
    {
        $xmlDebug = dom_import_simplexml($this->xmlDataSXF)->ownerDocument;
        $xmlDebug->preserveWhiteSpace = false;
        $xmlDebug->formatOutput = true;

        self::$debugXML = $xmlDebug->saveXML();
    }

    /**
     * @return string
     */
    public static function debugHead()
    {
        $debugBar = new StandardDebugBar();
        $debugBarRenderer = $debugBar->getJavascriptRenderer();

        return $debugBarRenderer->renderHead();
    }

    /**
     * @return string
     * @var \DebugBar\DataCollector\DataCollectorInterface
     * @var \DebugBar\StandardDebugBar
     */
    public static function debugBody()
    {
        $debugBar = new StandardDebugBar();
        $debugBarRenderer = $debugBar->getJavascriptRenderer();

        if (false === $debugBar->hasCollector('XML')) {
            $debugBar->addCollector(new DataCollector\MessagesCollector('XML'));

            /** @noinspection PhpUndefinedMethodInspection */
            $debugBar->getCollector('XML')->addMessage(self::$debugXML, 'info', false);
        }

        if (false === $debugBar->hasCollector('View')) {
            $debugBar->addCollector(new DataCollector\MessagesCollector('View'));

            /** @noinspection PhpUndefinedMethodInspection */
            $debugBar->getCollector('View')->addMessage(self::$xslTemplateFile, 'info', false);
        }

        if (false === $debugBar->hasCollector('Controller')) {
            $debugBar->addCollector(new DataCollector\MessagesCollector('Controller'));

            /** @noinspection PhpUndefinedMethodInspection */
            $debugBar->getCollector('Controller')->addMessage(self::$requestedController . '::' . self::$requestedFunction, 'info', false);
        }

        return $debugBarRenderer->render();
    }
}
