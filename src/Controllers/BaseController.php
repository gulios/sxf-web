<?php
namespace SXF\Web\Controllers;

use SXF\Config\Config;
use SXF\XML\SimpleXML;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class BaseController
 * @package SXF\Controllers
 */
class BaseController
{
    /**
     * @var BaseController
     */
    public $sxf;

    /**
     * @var SimpleXML
     */
    public $xmlDataSXF;

    /**
     * @var SimpleXML
     */
    public $xmlDataController;

    /**
     * @var SimpleXML
     */
    public static $xslTemplateFile;

    /**
     * @var Request
     */
    public $request;

    /**
     * @var WebController
     */
    public $maxmind;

    /**
     * @var Config
     */
    public $configuration;

    /**
     * BaseController constructor.
     * @param $objectSXF
     */
    public function __construct($objectSXF)
    {
        $this->sxf = $objectSXF;
        $this->sxf->configuration = $objectSXF->configuration;
    }

    /**
     * @param $viewFile
     * @return string
     */
    public function view($viewFile)
    {
        return $this->sxf::$xslTemplateFile = $this->sxf->configuration->get('app.paths.views') . $viewFile;
    }
}
