--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- mapinfo.lua
--

local mapinfo = {
	name        = "Eyam",
	shortname   = "Eyam",
	description = "20x20, made by Bluestone for LD43.",
	author      = "Bluestone",
	version     = "",
	--mutator   = "deployment";
	--mapfile   = "", --// location of smf/sm3 file (optional)
	modtype     = 3, --// 1=primary, 0=hidden, 3=map
	depend      = {"Map Helper v1"},
	replace     = {},

	--startpic   = "", --// deprecated
	--StartMusic = "", --// deprecated

	maphardness     = 315,
	notDeformable   = false,
	gravity         = 115,
	tidalStrength   = 16,
	maxMetal        = 2.95,
	extractorRadius = 90,
	voidWater       = true,
	autoShowMetal   = true,

	smf = {
		minheight = 0,
		maxheight = 2400,
		--smtFileName0 = "",
		--smtFileName1 = "",
		--smtFileName.. = "",
		--smtFileNameN = "",
	},

	resources = {
		--grassBladeTex    	= "grassbladetex.bmp",
		--grassShadingTex  	= "grassshading.bmp",
		specularTex = "specular.png",
--		splatDetailTex = "Zsplat.dds",
		splatDetailNormalDiffuseAlpha = 1,
		splatDetailNormalTex1 = "dnts1.png",
		splatDetailNormalTex2 = "dnts2.png",
		splatDetailNormalTex3 = "dnts3.png",
		splatDetailNormalTex4 = "dnts4.png",
		splatDistrTex = "shading-splat_distr.png",
		detailNormalTex = "normal.png",
		--lightEmissionTex = "",
	},

	splats = {
		TexScales		=	{ 0.006, 0.004, 0.003, 0.006 },
		TexMults		=	{ 0.8, 0.9, 0.15, 0.2 },
	},

	atmosphere = {

		minWind      = 2,
		maxWind      = 16,

		fogStart     = 0.5,
		fogEnd       = 1.0,
		fogColor     = {0.74, 0.78, 0.7},

		sunColor     = {1.0, 1.0, 1.0},
		skycolor     = {0.60, 0.78, 0.86},
		skyDir       = {0.0, 0.0, -1.0},
		skyBox       = "cleardesert.dds",

		cloudDensity = 0.65,
		cloudColor   = {0.11, 0.18, 0.27},
	},

	grass = {
		bladeWaveScale = 1.0,
		bladeWidth  = 0.5,
		bladeHeight = 6.0,
		bladeAngle  = 1.57,
		bladeColor  = {0.59, 0.81, 0.57}, --// does nothing when `grassBladeTex` is set
	},

	lighting = {
		--// dynsun
		sunStartAngle = 0.0,
		sunOrbitTime  = 1440.0,
		sundir        = { 1, 0.625, -0.5 },

		--// unit & ground lighting
         groundambientcolor            = { 1, 1, 1 },
         grounddiffusecolor            = { 1, 1, 1 },
         groundshadowdensity           = 0.95,
         unitambientcolor           = { 0.25, 0.25, 0.25 },
         unitdiffusecolor           = { 0.98, 0.78, 0.59 },
         unitshadowdensity          = 0.95,
	},

	water = {
		damage =  2000,

		repeatX = 0.0,
		repeatY = 0.0,

		absorb    = { 0.001, 0.001, 0.001 },
		basecolor = { 1, 1, 1 },
		mincolor  = { 0.5, 0.5, 0.5 },

		ambientFactor  = 1.0,
		diffuseFactor  = 1.0,
		specularFactor = 1.0,
		specularPower  = 20.0,

		surfacecolor  = { 0.4, 0.6, 0.4 },
		surfaceAlpha  = 0.5,
		diffuseColor  = {1.0, 1.0, 1.0},
		specularColor = {0.5, 0.5, 0.5},

		fresnelMin   = 0.2,
		fresnelMax   = 0.8,
		fresnelPower = 4.0,

		reflectionDistortion = 1.0,

		blurBase      = 2.0,
		blurExponent = 1.5,

		perlinStartFreq  =  8.0,
		perlinLacunarity = 3.0,
		perlinAmplitude  =  0.9,
		windSpeed = 1.0, --// does nothing yet

		shoreWaves = true,
		forceRendering = false,

		--// undefined == load them from resources.lua!
		--texture =       "",
		--foamTexture =   "",
		--normalTexture = "",
		--caustics = {
		--	"",
		--	"",
		--},
	},

	teams = {
		[0] = {startPos = {x = 2649, z = 1731}},
		[1] = {startPos = {x = 7997, z = 3541}},
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Helper

local function lowerkeys(ta)
	local fix = {}
	for i,v in pairs(ta) do
		if (type(i) == "string") then
			if (i ~= i:lower()) then
				fix[#fix+1] = i
			end
		end
		if (type(v) == "table") then
			lowerkeys(v)
		end
	end
	
	for i=1,#fix do
		local idx = fix[i]
		ta[idx:lower()] = ta[idx]
		ta[idx] = nil
	end
end

lowerkeys(mapinfo)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Map Options

do
	local function tmerge(t1, t2)
		for i,v in pairs(t2) do
			if (type(v) == "table") then
				t1[i] = t1[i] or {}
				tmerge(t1[i], v)
			else
				t1[i] = v
			end
		end
	end

	getfenv()["mapinfo"] = mapinfo
		local files = VFS.DirList("mapconfig/mapinfo/", "*.lua")
		table.sort(files)
		for i=1,#files do
			local newcfg = VFS.Include(files[i])
			if newcfg then
				lowerkeys(newcfg)
				tmerge(mapinfo, newcfg)
			end
		end
	getfenv()["mapinfo"] = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return mapinfo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
