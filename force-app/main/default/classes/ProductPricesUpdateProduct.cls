public class ProductPricesUpdateProduct {
	
    /*
    public void updateProductsSetMapPricingField()
    {
       updateProductsSetMapPricingFieldHelper(0, 200);
    }
    
    public void updateProductsSetMapPricingFieldPt2()
    {
       updateProductsSetMapPricingFieldHelper(200, 400);
    }
    
    public void updateProductsSetMapPricingFieldPt3()
    {
       updateProductsSetMapPricingFieldHelper(400, 600);
    }
    
    public void updateProductsSetMapPricingFieldPt4()
    {
       updateProductsSetMapPricingFieldHelper(600, 800);
    }*/
    
    public void updateProductsSetMapPricingFieldStartEnd(Integer startIndex, Integer endIndex)
    {
       updateProductsSetMapPricingFieldHelper(startIndex, endIndex);
    }
    
    
    private void updateProductsSetMapPricingFieldHelper(Integer startIndex, Integer endIndex)
    {
        List<Product2> data = new List<Product2>();
        Product2 obj = new Product2();
        
        List<MapProductPrices> productPrices = ProductPricesAbacusCtrl.getProductsPrices();
        
        System.debug('###########################################################################################################');
        System.debug('#'+ productPrices.size());
        
        /*
        List<MapProductPrices> tmp = new List<MapProductPrices>();
        tmp.add(productPrices.get(0));
        productPrices = tmp;
        System.debug('###########################################################################################################');
        System.debug('#'+ productPrices.size());*/
        
        
        List<String> productCodes = new List<String>();
        Integer priceCounter = 0;
        for(MapProductPrices currentProductPrice : productPrices)
        {	
            if(priceCounter >= startIndex && priceCounter <= endIndex) {
               productCodes.add(currentProductPrice.orderingNumber);
            }
            
            priceCounter++;
        }
       
        
        System.debug('###########################################################################################################');
        System.debug('#'+ productCodes.size());
        
        
        List<Product2> products = [SELECT Id, ProductCode,	Abacus_Konditionsnummer_101__c, Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c FROM Product2 WHERE ProductCode IN: productCodes LIMIT 50000];
        System.debug('#'+ products.size());
        Integer counter = 0;
       
        for(Product2 product : products)
        {
            product.MAP_pricing__c = TRUE;
            
     //       System.debug('####################################################yes#######################################################');
            counter++;
        }
     
        
        System.debug('###########################################################################################################');
        System.debug('#'+ data.size());
        System.debug('#'+ products.size());
        System.debug('#updated'+ counter);

		update products;
    }
    
    public void updateProducts()
    {
        List<Product2> data = new List<Product2>();
        Product2 obj = new Product2();

        obj = new Product2(); obj.ProductCode= 'CB-OBS418I-04'; obj.Abacus_Konditionsnummer_101__c= 2434; obj.Abacus_Konditionsnummer_102__c= 2348;obj.Abacus_Konditionsnummer_103__c=2520; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-OBS418X-04'; obj.Abacus_Konditionsnummer_101__c= 2435; obj.Abacus_Konditionsnummer_102__c= 2349;obj.Abacus_Konditionsnummer_103__c=2521; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-OBS419I-04'; obj.Abacus_Konditionsnummer_101__c= 2436; obj.Abacus_Konditionsnummer_102__c= 2350;obj.Abacus_Konditionsnummer_103__c=2522; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-OBS419X-04'; obj.Abacus_Konditionsnummer_101__c= 2438; obj.Abacus_Konditionsnummer_102__c= 2352;obj.Abacus_Konditionsnummer_103__c=2524; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-OBS421I-24'; obj.Abacus_Konditionsnummer_101__c= 2440; obj.Abacus_Konditionsnummer_102__c= 2354;obj.Abacus_Konditionsnummer_103__c=2526; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-OBS421X-24'; obj.Abacus_Konditionsnummer_101__c= 2447; obj.Abacus_Konditionsnummer_102__c= 2361;obj.Abacus_Konditionsnummer_103__c=2533; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-OWS451I-04'; obj.Abacus_Konditionsnummer_101__c= 2464; obj.Abacus_Konditionsnummer_102__c= 2378;obj.Abacus_Konditionsnummer_103__c=2550; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B111'; obj.Abacus_Konditionsnummer_101__c= 2477; obj.Abacus_Konditionsnummer_102__c= 2391;obj.Abacus_Konditionsnummer_103__c=2563; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B112'; obj.Abacus_Konditionsnummer_101__c= 2478; obj.Abacus_Konditionsnummer_102__c= 2392;obj.Abacus_Konditionsnummer_103__c=2564; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-W101'; obj.Abacus_Konditionsnummer_101__c= 2479; obj.Abacus_Konditionsnummer_102__c= 2393;obj.Abacus_Konditionsnummer_103__c=2565; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-W102'; obj.Abacus_Konditionsnummer_101__c= 2480; obj.Abacus_Konditionsnummer_102__c= 2394;obj.Abacus_Konditionsnummer_103__c=2566; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-W131'; obj.Abacus_Konditionsnummer_101__c= 2481; obj.Abacus_Konditionsnummer_102__c= 2395;obj.Abacus_Konditionsnummer_103__c=2567; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-W132'; obj.Abacus_Konditionsnummer_101__c= 2482; obj.Abacus_Konditionsnummer_102__c= 2396;obj.Abacus_Konditionsnummer_103__c=2568; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-W151'; obj.Abacus_Konditionsnummer_101__c= 2483; obj.Abacus_Konditionsnummer_102__c= 2397;obj.Abacus_Konditionsnummer_103__c=2569; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-W152'; obj.Abacus_Konditionsnummer_101__c= 2484; obj.Abacus_Konditionsnummer_102__c= 2398;obj.Abacus_Konditionsnummer_103__c=2570; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-ODIN-W260'; obj.Abacus_Konditionsnummer_101__c= 2485; obj.Abacus_Konditionsnummer_102__c= 2399;obj.Abacus_Konditionsnummer_103__c=2571; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-ODIN-W262'; obj.Abacus_Konditionsnummer_101__c= 2486; obj.Abacus_Konditionsnummer_102__c= 2400;obj.Abacus_Konditionsnummer_103__c=2572; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-W262U'; obj.Abacus_Konditionsnummer_101__c= 2487; obj.Abacus_Konditionsnummer_102__c= 2401;obj.Abacus_Konditionsnummer_103__c=2573; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B111-00B'; obj.Abacus_Konditionsnummer_101__c= 2491; obj.Abacus_Konditionsnummer_102__c= 2405;obj.Abacus_Konditionsnummer_103__c=2577; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B111-01B'; obj.Abacus_Konditionsnummer_101__c= 2492; obj.Abacus_Konditionsnummer_102__c= 2406;obj.Abacus_Konditionsnummer_103__c=2578; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B111-02B'; obj.Abacus_Konditionsnummer_101__c= 2493; obj.Abacus_Konditionsnummer_102__c= 2407;obj.Abacus_Konditionsnummer_103__c=2579; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B112-00B'; obj.Abacus_Konditionsnummer_101__c= 2494; obj.Abacus_Konditionsnummer_102__c= 2408;obj.Abacus_Konditionsnummer_103__c=2580; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B112-01B'; obj.Abacus_Konditionsnummer_101__c= 2495; obj.Abacus_Konditionsnummer_102__c= 2409;obj.Abacus_Konditionsnummer_103__c=2581; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B112-02B'; obj.Abacus_Konditionsnummer_101__c= 2496; obj.Abacus_Konditionsnummer_102__c= 2410;obj.Abacus_Konditionsnummer_103__c=2582; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-W101-00B'; obj.Abacus_Konditionsnummer_101__c= 2497; obj.Abacus_Konditionsnummer_102__c= 2411;obj.Abacus_Konditionsnummer_103__c=2583; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-W102-00B'; obj.Abacus_Konditionsnummer_101__c= 2498; obj.Abacus_Konditionsnummer_102__c= 2412;obj.Abacus_Konditionsnummer_103__c=2584; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-W151-00B'; obj.Abacus_Konditionsnummer_101__c= 2501; obj.Abacus_Konditionsnummer_102__c= 2415;obj.Abacus_Konditionsnummer_103__c=2587; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-W152-00B'; obj.Abacus_Konditionsnummer_101__c= 2502; obj.Abacus_Konditionsnummer_102__c= 2416;obj.Abacus_Konditionsnummer_103__c=2588; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ODIN-W260-04B'; obj.Abacus_Konditionsnummer_101__c= 2509; obj.Abacus_Konditionsnummer_102__c= 2423;obj.Abacus_Konditionsnummer_103__c=2595; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ODIN-W262-04B'; obj.Abacus_Konditionsnummer_101__c= 2517; obj.Abacus_Konditionsnummer_102__c= 2431;obj.Abacus_Konditionsnummer_103__c=2603; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-G350-02S'; obj.Abacus_Konditionsnummer_101__c= 2726; obj.Abacus_Konditionsnummer_102__c= 2610;obj.Abacus_Konditionsnummer_103__c=2848; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-L201-00S'; obj.Abacus_Konditionsnummer_101__c= 2727; obj.Abacus_Konditionsnummer_102__c= 2611;obj.Abacus_Konditionsnummer_103__c=2849; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-L220-00S'; obj.Abacus_Konditionsnummer_101__c= 2728; obj.Abacus_Konditionsnummer_102__c= 2612;obj.Abacus_Konditionsnummer_103__c=2850; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R200-00B'; obj.Abacus_Konditionsnummer_101__c= 2729; obj.Abacus_Konditionsnummer_102__c= 2613;obj.Abacus_Konditionsnummer_103__c=2851; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R202-00B'; obj.Abacus_Konditionsnummer_101__c= 2730; obj.Abacus_Konditionsnummer_102__c= 2614;obj.Abacus_Konditionsnummer_103__c=2852; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R204-00B'; obj.Abacus_Konditionsnummer_101__c= 2731; obj.Abacus_Konditionsnummer_102__c= 2615;obj.Abacus_Konditionsnummer_103__c=2853; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R211-00B'; obj.Abacus_Konditionsnummer_101__c= 2732; obj.Abacus_Konditionsnummer_102__c= 2616;obj.Abacus_Konditionsnummer_103__c=2854; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-U200-01S'; obj.Abacus_Konditionsnummer_101__c= 2733; obj.Abacus_Konditionsnummer_102__c= 2617;obj.Abacus_Konditionsnummer_103__c=2855; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-U230-01S'; obj.Abacus_Konditionsnummer_101__c= 2735; obj.Abacus_Konditionsnummer_102__c= 2619;obj.Abacus_Konditionsnummer_103__c=2857; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-U270-00S'; obj.Abacus_Konditionsnummer_101__c= 2736; obj.Abacus_Konditionsnummer_102__c= 2620;obj.Abacus_Konditionsnummer_103__c=2858; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C027-G35-0'; obj.Abacus_Konditionsnummer_101__c= 2739; obj.Abacus_Konditionsnummer_102__c= 2621;obj.Abacus_Konditionsnummer_103__c=2861; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C027-U20-0'; obj.Abacus_Konditionsnummer_101__c= 2740; obj.Abacus_Konditionsnummer_102__c= 2622;obj.Abacus_Konditionsnummer_103__c=2862; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C030-N211-0'; obj.Abacus_Konditionsnummer_101__c= 2741; obj.Abacus_Konditionsnummer_102__c= 2623;obj.Abacus_Konditionsnummer_103__c=2863; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-G35-02S'; obj.Abacus_Konditionsnummer_101__c= 2749; obj.Abacus_Konditionsnummer_102__c= 2627;obj.Abacus_Konditionsnummer_103__c=2871; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-L20-00S'; obj.Abacus_Konditionsnummer_101__c= 2750; obj.Abacus_Konditionsnummer_102__c= 2628;obj.Abacus_Konditionsnummer_103__c=2872; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-L21-00S'; obj.Abacus_Konditionsnummer_101__c= 2751; obj.Abacus_Konditionsnummer_102__c= 2629;obj.Abacus_Konditionsnummer_103__c=2873; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-L22-00S'; obj.Abacus_Konditionsnummer_101__c= 2752; obj.Abacus_Konditionsnummer_102__c= 2630;obj.Abacus_Konditionsnummer_103__c=2874; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-L23-00S'; obj.Abacus_Konditionsnummer_101__c= 2753; obj.Abacus_Konditionsnummer_102__c= 2631;obj.Abacus_Konditionsnummer_103__c=2875; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-L24-00S'; obj.Abacus_Konditionsnummer_101__c= 2754; obj.Abacus_Konditionsnummer_102__c= 2632;obj.Abacus_Konditionsnummer_103__c=2876; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R200-00B'; obj.Abacus_Konditionsnummer_101__c= 2755; obj.Abacus_Konditionsnummer_102__c= 2633;obj.Abacus_Konditionsnummer_103__c=2877; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R202-00B'; obj.Abacus_Konditionsnummer_101__c= 2756; obj.Abacus_Konditionsnummer_102__c= 2634;obj.Abacus_Konditionsnummer_103__c=2878; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R204-00B'; obj.Abacus_Konditionsnummer_101__c= 2757; obj.Abacus_Konditionsnummer_102__c= 2635;obj.Abacus_Konditionsnummer_103__c=2879; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R211-00B'; obj.Abacus_Konditionsnummer_101__c= 2758; obj.Abacus_Konditionsnummer_102__c= 2636;obj.Abacus_Konditionsnummer_103__c=2880; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-S10NANO-00C'; obj.Abacus_Konditionsnummer_101__c= 2760; obj.Abacus_Konditionsnummer_102__c= 2638;obj.Abacus_Konditionsnummer_103__c=2882; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-U20-01S'; obj.Abacus_Konditionsnummer_101__c= 2762; obj.Abacus_Konditionsnummer_102__c= 2640;obj.Abacus_Konditionsnummer_103__c=2884; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-U201SARA-0'; obj.Abacus_Konditionsnummer_101__c= 2763; obj.Abacus_Konditionsnummer_102__c= 2641;obj.Abacus_Konditionsnummer_103__c=2885; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-U23-01S'; obj.Abacus_Konditionsnummer_101__c= 2765; obj.Abacus_Konditionsnummer_102__c= 2643;obj.Abacus_Konditionsnummer_103__c=2887; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-U26-00S'; obj.Abacus_Konditionsnummer_101__c= 2766; obj.Abacus_Konditionsnummer_102__c= 2644;obj.Abacus_Konditionsnummer_103__c=2888; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-U27-00S'; obj.Abacus_Konditionsnummer_101__c= 2767; obj.Abacus_Konditionsnummer_102__c= 2645;obj.Abacus_Konditionsnummer_103__c=2889; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LARA-R203-02B'; obj.Abacus_Konditionsnummer_101__c= 2769; obj.Abacus_Konditionsnummer_102__c= 2647;obj.Abacus_Konditionsnummer_103__c=2891; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LARA-R204-02B'; obj.Abacus_Konditionsnummer_101__c= 2770; obj.Abacus_Konditionsnummer_102__c= 2648;obj.Abacus_Konditionsnummer_103__c=2892; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LISA-U201-03S'; obj.Abacus_Konditionsnummer_101__c= 2786; obj.Abacus_Konditionsnummer_102__c= 2664;obj.Abacus_Konditionsnummer_103__c=2908; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MPCI-L200-03S'; obj.Abacus_Konditionsnummer_101__c= 2796; obj.Abacus_Konditionsnummer_102__c= 2674;obj.Abacus_Konditionsnummer_103__c=2918; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MPCI-L201-02S'; obj.Abacus_Konditionsnummer_101__c= 2798; obj.Abacus_Konditionsnummer_102__c= 2676;obj.Abacus_Konditionsnummer_103__c=2920; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MPCI-L210-03S'; obj.Abacus_Konditionsnummer_101__c= 2800; obj.Abacus_Konditionsnummer_102__c= 2678;obj.Abacus_Konditionsnummer_103__c=2922; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MPCI-L220-02S'; obj.Abacus_Konditionsnummer_101__c= 2801; obj.Abacus_Konditionsnummer_102__c= 2679;obj.Abacus_Konditionsnummer_103__c=2923; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MPCI-L280-03S'; obj.Abacus_Konditionsnummer_101__c= 2804; obj.Abacus_Konditionsnummer_102__c= 2682;obj.Abacus_Konditionsnummer_103__c=2926; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-G340-02S'; obj.Abacus_Konditionsnummer_101__c= 2810; obj.Abacus_Konditionsnummer_102__c= 2688;obj.Abacus_Konditionsnummer_103__c=2932; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-G350-02S'; obj.Abacus_Konditionsnummer_101__c= 2814; obj.Abacus_Konditionsnummer_102__c= 2692;obj.Abacus_Konditionsnummer_103__c=2936; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-N200-02B'; obj.Abacus_Konditionsnummer_101__c= 2815; obj.Abacus_Konditionsnummer_102__c= 2693;obj.Abacus_Konditionsnummer_103__c=2937; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-R410M-02B'; obj.Abacus_Konditionsnummer_101__c= 2818; obj.Abacus_Konditionsnummer_102__c= 2696;obj.Abacus_Konditionsnummer_103__c=2940; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-U260-03S'; obj.Abacus_Konditionsnummer_101__c= 2824; obj.Abacus_Konditionsnummer_102__c= 2702;obj.Abacus_Konditionsnummer_103__c=2946; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-U270-03S'; obj.Abacus_Konditionsnummer_101__c= 2826; obj.Abacus_Konditionsnummer_102__c= 2704;obj.Abacus_Konditionsnummer_103__c=2948; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-U280-03S'; obj.Abacus_Konditionsnummer_101__c= 2830; obj.Abacus_Konditionsnummer_102__c= 2708;obj.Abacus_Konditionsnummer_103__c=2952; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L200-03S'; obj.Abacus_Konditionsnummer_101__c= 2832; obj.Abacus_Konditionsnummer_102__c= 2710;obj.Abacus_Konditionsnummer_103__c=2954; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L201-02S'; obj.Abacus_Konditionsnummer_101__c= 2834; obj.Abacus_Konditionsnummer_102__c= 2712;obj.Abacus_Konditionsnummer_103__c=2956; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L210-03S'; obj.Abacus_Konditionsnummer_101__c= 2836; obj.Abacus_Konditionsnummer_102__c= 2714;obj.Abacus_Konditionsnummer_103__c=2958; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L210-62S'; obj.Abacus_Konditionsnummer_101__c= 2837; obj.Abacus_Konditionsnummer_102__c= 2715;obj.Abacus_Konditionsnummer_103__c=2959; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L220-02S'; obj.Abacus_Konditionsnummer_101__c= 2838; obj.Abacus_Konditionsnummer_102__c= 2716;obj.Abacus_Konditionsnummer_103__c=2960; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L220-62S'; obj.Abacus_Konditionsnummer_101__c= 2839; obj.Abacus_Konditionsnummer_102__c= 2717;obj.Abacus_Konditionsnummer_103__c=2961; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-L280-03S'; obj.Abacus_Konditionsnummer_101__c= 2841; obj.Abacus_Konditionsnummer_102__c= 2719;obj.Abacus_Konditionsnummer_103__c=2963; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-R202-02B'; obj.Abacus_Konditionsnummer_101__c= 2843; obj.Abacus_Konditionsnummer_102__c= 2721;obj.Abacus_Konditionsnummer_103__c=2965; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ACE-AM-0'; obj.Abacus_Konditionsnummer_101__c= 3046; obj.Abacus_Konditionsnummer_102__c= 2966;obj.Abacus_Konditionsnummer_103__c=3126; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANN-MS-0-005-0'; obj.Abacus_Konditionsnummer_101__c= 3048; obj.Abacus_Konditionsnummer_102__c= 2968;obj.Abacus_Konditionsnummer_103__c=3128; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANN-MS-1-005-0'; obj.Abacus_Konditionsnummer_101__c= 3049; obj.Abacus_Konditionsnummer_102__c= 2969;obj.Abacus_Konditionsnummer_103__c=3129; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANN-MS-2-005-0'; obj.Abacus_Konditionsnummer_101__c= 3050; obj.Abacus_Konditionsnummer_102__c= 2970;obj.Abacus_Konditionsnummer_103__c=3130; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CAM-M8C-0'; obj.Abacus_Konditionsnummer_101__c= 3054; obj.Abacus_Konditionsnummer_102__c= 2974;obj.Abacus_Konditionsnummer_103__c=3134; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CAM-M8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3055; obj.Abacus_Konditionsnummer_102__c= 2975;obj.Abacus_Konditionsnummer_103__c=3135; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVA-7M-0'; obj.Abacus_Konditionsnummer_101__c= 3056; obj.Abacus_Konditionsnummer_102__c= 2976;obj.Abacus_Konditionsnummer_103__c=3136; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVA-8M-0'; obj.Abacus_Konditionsnummer_101__c= 3057; obj.Abacus_Konditionsnummer_102__c= 2977;obj.Abacus_Konditionsnummer_103__c=3137; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVA-M8M-0'; obj.Abacus_Konditionsnummer_101__c= 3059; obj.Abacus_Konditionsnummer_102__c= 2979;obj.Abacus_Konditionsnummer_103__c=3139; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVA-M8M-1'; obj.Abacus_Konditionsnummer_101__c= 3060; obj.Abacus_Konditionsnummer_102__c= 2980;obj.Abacus_Konditionsnummer_103__c=3140; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVA-M8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3061; obj.Abacus_Konditionsnummer_102__c= 2981;obj.Abacus_Konditionsnummer_103__c=3141; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-7P-0'; obj.Abacus_Konditionsnummer_101__c= 3062; obj.Abacus_Konditionsnummer_102__c= 2982;obj.Abacus_Konditionsnummer_103__c=3142; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-8N-0'; obj.Abacus_Konditionsnummer_101__c= 3063; obj.Abacus_Konditionsnummer_102__c= 2983;obj.Abacus_Konditionsnummer_103__c=3143; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8BZOE-0'; obj.Abacus_Konditionsnummer_101__c= 3065; obj.Abacus_Konditionsnummer_102__c= 2985;obj.Abacus_Konditionsnummer_103__c=3145; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8C-0'; obj.Abacus_Konditionsnummer_101__c= 3066; obj.Abacus_Konditionsnummer_102__c= 2986;obj.Abacus_Konditionsnummer_103__c=3146; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8CCAM-0'; obj.Abacus_Konditionsnummer_101__c= 3067; obj.Abacus_Konditionsnummer_102__c= 2987;obj.Abacus_Konditionsnummer_103__c=3147; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8F-0'; obj.Abacus_Konditionsnummer_101__c= 3068; obj.Abacus_Konditionsnummer_102__c= 2988;obj.Abacus_Konditionsnummer_103__c=3148; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8GZOE-0'; obj.Abacus_Konditionsnummer_101__c= 3069; obj.Abacus_Konditionsnummer_102__c= 2989;obj.Abacus_Konditionsnummer_103__c=3149; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8MEVA-0'; obj.Abacus_Konditionsnummer_101__c= 3071; obj.Abacus_Konditionsnummer_102__c= 2991;obj.Abacus_Konditionsnummer_103__c=3151; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8N-0'; obj.Abacus_Konditionsnummer_101__c= 3072; obj.Abacus_Konditionsnummer_102__c= 2992;obj.Abacus_Konditionsnummer_103__c=3152; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8QCAM-0'; obj.Abacus_Konditionsnummer_101__c= 3073; obj.Abacus_Konditionsnummer_102__c= 2993;obj.Abacus_Konditionsnummer_103__c=3153; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8QEVA-0'; obj.Abacus_Konditionsnummer_101__c= 3074; obj.Abacus_Konditionsnummer_102__c= 2994;obj.Abacus_Konditionsnummer_103__c=3154; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8QSAM-0'; obj.Abacus_Konditionsnummer_101__c= 3075; obj.Abacus_Konditionsnummer_102__c= 2995;obj.Abacus_Konditionsnummer_103__c=3155; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8T-0'; obj.Abacus_Konditionsnummer_101__c= 3076; obj.Abacus_Konditionsnummer_102__c= 2996;obj.Abacus_Konditionsnummer_103__c=3156; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-M8U-0'; obj.Abacus_Konditionsnummer_101__c= 3077; obj.Abacus_Konditionsnummer_102__c= 2997;obj.Abacus_Konditionsnummer_103__c=3157; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-6A-0'; obj.Abacus_Konditionsnummer_101__c= 3080; obj.Abacus_Konditionsnummer_102__c= 3000;obj.Abacus_Konditionsnummer_103__c=3160; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-6H-0'; obj.Abacus_Konditionsnummer_101__c= 3081; obj.Abacus_Konditionsnummer_102__c= 3001;obj.Abacus_Konditionsnummer_103__c=3161; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-6R-0'; obj.Abacus_Konditionsnummer_101__c= 3083; obj.Abacus_Konditionsnummer_102__c= 3003;obj.Abacus_Konditionsnummer_103__c=3163; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-6S-0'; obj.Abacus_Konditionsnummer_101__c= 3084; obj.Abacus_Konditionsnummer_102__c= 3004;obj.Abacus_Konditionsnummer_103__c=3164; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-6T-0'; obj.Abacus_Konditionsnummer_101__c= 3085; obj.Abacus_Konditionsnummer_102__c= 3005;obj.Abacus_Konditionsnummer_103__c=3165; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-6T-1'; obj.Abacus_Konditionsnummer_101__c= 3086; obj.Abacus_Konditionsnummer_102__c= 3006;obj.Abacus_Konditionsnummer_103__c=3166; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-M8F-0'; obj.Abacus_Konditionsnummer_101__c= 3087; obj.Abacus_Konditionsnummer_102__c= 3007;obj.Abacus_Konditionsnummer_103__c=3167; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-M8S-0'; obj.Abacus_Konditionsnummer_101__c= 3088; obj.Abacus_Konditionsnummer_102__c= 3008;obj.Abacus_Konditionsnummer_103__c=3168; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LEA-M8T-0'; obj.Abacus_Konditionsnummer_101__c= 3089; obj.Abacus_Konditionsnummer_102__c= 3009;obj.Abacus_Konditionsnummer_103__c=3169; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-7C-0'; obj.Abacus_Konditionsnummer_101__c= 3092; obj.Abacus_Konditionsnummer_102__c= 3012;obj.Abacus_Konditionsnummer_103__c=3172; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-7Q-0'; obj.Abacus_Konditionsnummer_101__c= 3093; obj.Abacus_Konditionsnummer_102__c= 3013;obj.Abacus_Konditionsnummer_103__c=3173; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-7W-0'; obj.Abacus_Konditionsnummer_101__c= 3094; obj.Abacus_Konditionsnummer_102__c= 3014;obj.Abacus_Konditionsnummer_103__c=3174; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-8C-0'; obj.Abacus_Konditionsnummer_101__c= 3095; obj.Abacus_Konditionsnummer_102__c= 3015;obj.Abacus_Konditionsnummer_103__c=3175; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3096; obj.Abacus_Konditionsnummer_102__c= 3016;obj.Abacus_Konditionsnummer_103__c=3176; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-M8C-0'; obj.Abacus_Konditionsnummer_101__c= 3098; obj.Abacus_Konditionsnummer_102__c= 3018;obj.Abacus_Konditionsnummer_103__c=3178; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-M8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3099; obj.Abacus_Konditionsnummer_102__c= 3019;obj.Abacus_Konditionsnummer_103__c=3179; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MAX-M8W-0'; obj.Abacus_Konditionsnummer_101__c= 3100; obj.Abacus_Konditionsnummer_102__c= 3020;obj.Abacus_Konditionsnummer_103__c=3180; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-6G-0'; obj.Abacus_Konditionsnummer_101__c= 3101; obj.Abacus_Konditionsnummer_102__c= 3021;obj.Abacus_Konditionsnummer_103__c=3181; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-6M-0'; obj.Abacus_Konditionsnummer_101__c= 3102; obj.Abacus_Konditionsnummer_102__c= 3022;obj.Abacus_Konditionsnummer_103__c=3182; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-6Q-0'; obj.Abacus_Konditionsnummer_101__c= 3103; obj.Abacus_Konditionsnummer_102__c= 3023;obj.Abacus_Konditionsnummer_103__c=3183; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-6T-0'; obj.Abacus_Konditionsnummer_101__c= 3104; obj.Abacus_Konditionsnummer_102__c= 3024;obj.Abacus_Konditionsnummer_103__c=3184; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-7M-0'; obj.Abacus_Konditionsnummer_101__c= 3106; obj.Abacus_Konditionsnummer_102__c= 3026;obj.Abacus_Konditionsnummer_103__c=3186; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-7N-0'; obj.Abacus_Konditionsnummer_101__c= 3107; obj.Abacus_Konditionsnummer_102__c= 3027;obj.Abacus_Konditionsnummer_103__c=3187; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-7P-0'; obj.Abacus_Konditionsnummer_101__c= 3109; obj.Abacus_Konditionsnummer_102__c= 3029;obj.Abacus_Konditionsnummer_103__c=3189; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3110; obj.Abacus_Konditionsnummer_102__c= 3030;obj.Abacus_Konditionsnummer_103__c=3190; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8M-0'; obj.Abacus_Konditionsnummer_101__c= 3112; obj.Abacus_Konditionsnummer_102__c= 3032;obj.Abacus_Konditionsnummer_103__c=3192; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8N-0'; obj.Abacus_Konditionsnummer_101__c= 3113; obj.Abacus_Konditionsnummer_102__c= 3033;obj.Abacus_Konditionsnummer_103__c=3193; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8P-0'; obj.Abacus_Konditionsnummer_101__c= 3114; obj.Abacus_Konditionsnummer_102__c= 3034;obj.Abacus_Konditionsnummer_103__c=3194; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8P-2'; obj.Abacus_Konditionsnummer_101__c= 3115; obj.Abacus_Konditionsnummer_102__c= 3035;obj.Abacus_Konditionsnummer_103__c=3195; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3116; obj.Abacus_Konditionsnummer_102__c= 3036;obj.Abacus_Konditionsnummer_103__c=3196; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8T-0'; obj.Abacus_Konditionsnummer_101__c= 3117; obj.Abacus_Konditionsnummer_102__c= 3037;obj.Abacus_Konditionsnummer_103__c=3197; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-M8U-0'; obj.Abacus_Konditionsnummer_101__c= 3118; obj.Abacus_Konditionsnummer_102__c= 3038;obj.Abacus_Konditionsnummer_103__c=3198; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'PAM-7Q-0'; obj.Abacus_Konditionsnummer_101__c= 3119; obj.Abacus_Konditionsnummer_102__c= 3039;obj.Abacus_Konditionsnummer_103__c=3199; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SAM-M8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3120; obj.Abacus_Konditionsnummer_102__c= 3040;obj.Abacus_Konditionsnummer_103__c=3200; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ZOE-M8B-0'; obj.Abacus_Konditionsnummer_101__c= 3123; obj.Abacus_Konditionsnummer_102__c= 3043;obj.Abacus_Konditionsnummer_103__c=3204; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ZOE-M8G-0'; obj.Abacus_Konditionsnummer_101__c= 3124; obj.Abacus_Konditionsnummer_102__c= 3044;obj.Abacus_Konditionsnummer_103__c=3205; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ZOE-M8Q-0'; obj.Abacus_Konditionsnummer_101__c= 3125; obj.Abacus_Konditionsnummer_102__c= 3045;obj.Abacus_Konditionsnummer_103__c=3206; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R203-00B'; obj.Abacus_Konditionsnummer_101__c= 3232; obj.Abacus_Konditionsnummer_102__c= 3207;obj.Abacus_Konditionsnummer_103__c=3257; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R220-00B'; obj.Abacus_Konditionsnummer_101__c= 3233; obj.Abacus_Konditionsnummer_102__c= 3208;obj.Abacus_Konditionsnummer_103__c=3258; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R280-00B'; obj.Abacus_Konditionsnummer_101__c= 3234; obj.Abacus_Konditionsnummer_102__c= 3209;obj.Abacus_Konditionsnummer_103__c=3259; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-U201SARA-0'; obj.Abacus_Konditionsnummer_101__c= 3235; obj.Abacus_Konditionsnummer_102__c= 3210;obj.Abacus_Konditionsnummer_103__c=3260; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C030-U201-0'; obj.Abacus_Konditionsnummer_101__c= 3236; obj.Abacus_Konditionsnummer_102__c= 3211;obj.Abacus_Konditionsnummer_103__c=3261; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-N200-02B'; obj.Abacus_Konditionsnummer_101__c= 3237; obj.Abacus_Konditionsnummer_102__c= 3212;obj.Abacus_Konditionsnummer_103__c=3262; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-N201-02B'; obj.Abacus_Konditionsnummer_101__c= 3238; obj.Abacus_Konditionsnummer_102__c= 3213;obj.Abacus_Konditionsnummer_103__c=3263; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-N210-02B'; obj.Abacus_Konditionsnummer_101__c= 3239; obj.Abacus_Konditionsnummer_102__c= 3214;obj.Abacus_Konditionsnummer_103__c=3264; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-N211-02B'; obj.Abacus_Konditionsnummer_101__c= 3240; obj.Abacus_Konditionsnummer_102__c= 3215;obj.Abacus_Konditionsnummer_103__c=3265; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-N280-02B'; obj.Abacus_Konditionsnummer_101__c= 3241; obj.Abacus_Konditionsnummer_102__c= 3216;obj.Abacus_Konditionsnummer_103__c=3266; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R203-00B'; obj.Abacus_Konditionsnummer_101__c= 3242; obj.Abacus_Konditionsnummer_102__c= 3217;obj.Abacus_Konditionsnummer_103__c=3267; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R220-00B'; obj.Abacus_Konditionsnummer_101__c= 3243; obj.Abacus_Konditionsnummer_102__c= 3218;obj.Abacus_Konditionsnummer_103__c=3268; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R280-00B'; obj.Abacus_Konditionsnummer_101__c= 3244; obj.Abacus_Konditionsnummer_102__c= 3219;obj.Abacus_Konditionsnummer_103__c=3269; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LARA-R211-02B'; obj.Abacus_Konditionsnummer_101__c= 3245; obj.Abacus_Konditionsnummer_102__c= 3220;obj.Abacus_Konditionsnummer_103__c=3270; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LARA-R220-62B'; obj.Abacus_Konditionsnummer_101__c= 3246; obj.Abacus_Konditionsnummer_102__c= 3221;obj.Abacus_Konditionsnummer_103__c=3271; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LARA-R280-02B'; obj.Abacus_Konditionsnummer_101__c= 3247; obj.Abacus_Konditionsnummer_102__c= 3222;obj.Abacus_Konditionsnummer_103__c=3272; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'MPCI-L210-60S'; obj.Abacus_Konditionsnummer_101__c= 3250; obj.Abacus_Konditionsnummer_102__c= 3225;obj.Abacus_Konditionsnummer_103__c=3275; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-N201-02B'; obj.Abacus_Konditionsnummer_101__c= 3251; obj.Abacus_Konditionsnummer_102__c= 3226;obj.Abacus_Konditionsnummer_103__c=3276; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-N210-02B'; obj.Abacus_Konditionsnummer_101__c= 3252; obj.Abacus_Konditionsnummer_102__c= 3227;obj.Abacus_Konditionsnummer_103__c=3277; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-N280-02B'; obj.Abacus_Konditionsnummer_101__c= 3254; obj.Abacus_Konditionsnummer_102__c= 3229;obj.Abacus_Konditionsnummer_103__c=3279; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-R412M-02B'; obj.Abacus_Konditionsnummer_101__c= 3255; obj.Abacus_Konditionsnummer_102__c= 3230;obj.Abacus_Konditionsnummer_103__c=3280; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-U201-04B'; obj.Abacus_Konditionsnummer_101__c= 3256; obj.Abacus_Konditionsnummer_102__c= 3231;obj.Abacus_Konditionsnummer_103__c=3281; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-L200-00S'; obj.Abacus_Konditionsnummer_101__c= 3294; obj.Abacus_Konditionsnummer_102__c= 3282;obj.Abacus_Konditionsnummer_103__c=3306; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-L210-00S'; obj.Abacus_Konditionsnummer_101__c= 3295; obj.Abacus_Konditionsnummer_102__c= 3283;obj.Abacus_Konditionsnummer_103__c=3307; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-L280-00S'; obj.Abacus_Konditionsnummer_101__c= 3296; obj.Abacus_Konditionsnummer_102__c= 3284;obj.Abacus_Konditionsnummer_103__c=3308; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C94-M8P-1'; obj.Abacus_Konditionsnummer_101__c= 3297; obj.Abacus_Konditionsnummer_102__c= 3285;obj.Abacus_Konditionsnummer_103__c=3309; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C94-M8P-2'; obj.Abacus_Konditionsnummer_101__c= 3298; obj.Abacus_Konditionsnummer_102__c= 3286;obj.Abacus_Konditionsnummer_103__c=3310; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C94-M8P-3'; obj.Abacus_Konditionsnummer_101__c= 3299; obj.Abacus_Konditionsnummer_102__c= 3287;obj.Abacus_Konditionsnummer_103__c=3311; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C94-M8P-4'; obj.Abacus_Konditionsnummer_101__c= 3300; obj.Abacus_Konditionsnummer_102__c= 3288;obj.Abacus_Konditionsnummer_103__c=3312; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-ACC-24'; obj.Abacus_Konditionsnummer_101__c= 3301; obj.Abacus_Konditionsnummer_102__c= 3289;obj.Abacus_Konditionsnummer_103__c=3313; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-ACC-25'; obj.Abacus_Konditionsnummer_101__c= 3302; obj.Abacus_Konditionsnummer_102__c= 3290;obj.Abacus_Konditionsnummer_103__c=3314; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'CB-ACC-34'; obj.Abacus_Konditionsnummer_101__c= 3303; obj.Abacus_Konditionsnummer_102__c= 3291;obj.Abacus_Konditionsnummer_103__c=3315; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NEO-6P-0'; obj.Abacus_Konditionsnummer_101__c= 3305; obj.Abacus_Konditionsnummer_102__c= 3293;obj.Abacus_Konditionsnummer_103__c=3317; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-U260-00S'; obj.Abacus_Konditionsnummer_101__c= 3323; obj.Abacus_Konditionsnummer_102__c= 3322;obj.Abacus_Konditionsnummer_103__c=3324; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-G45-0'; obj.Abacus_Konditionsnummer_101__c= 4530; obj.Abacus_Konditionsnummer_102__c= 4522;obj.Abacus_Konditionsnummer_103__c=4538; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R410M-02B'; obj.Abacus_Konditionsnummer_101__c= 4534; obj.Abacus_Konditionsnummer_102__c= 4526;obj.Abacus_Konditionsnummer_103__c=4542; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-R412M-02B'; obj.Abacus_Konditionsnummer_101__c= 4535; obj.Abacus_Konditionsnummer_102__c= 4527;obj.Abacus_Konditionsnummer_103__c=4543; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-G450-00C'; obj.Abacus_Konditionsnummer_101__c= 4536; obj.Abacus_Konditionsnummer_102__c= 4528;obj.Abacus_Konditionsnummer_103__c=4544; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANNA-B112-00B'; obj.Abacus_Konditionsnummer_101__c= 4565; obj.Abacus_Konditionsnummer_102__c= 4545;obj.Abacus_Konditionsnummer_103__c=4585; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B221'; obj.Abacus_Konditionsnummer_101__c= 4571; obj.Abacus_Konditionsnummer_102__c= 4551;obj.Abacus_Konditionsnummer_103__c=4591; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B222'; obj.Abacus_Konditionsnummer_101__c= 4572; obj.Abacus_Konditionsnummer_102__c= 4552;obj.Abacus_Konditionsnummer_103__c=4592; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B301'; obj.Abacus_Konditionsnummer_101__c= 4573; obj.Abacus_Konditionsnummer_102__c= 4553;obj.Abacus_Konditionsnummer_103__c=4593; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B302'; obj.Abacus_Konditionsnummer_101__c= 4574; obj.Abacus_Konditionsnummer_102__c= 4554;obj.Abacus_Konditionsnummer_103__c=4594; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B311'; obj.Abacus_Konditionsnummer_101__c= 4575; obj.Abacus_Konditionsnummer_102__c= 4555;obj.Abacus_Konditionsnummer_103__c=4595; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B312'; obj.Abacus_Konditionsnummer_101__c= 4576; obj.Abacus_Konditionsnummer_102__c= 4556;obj.Abacus_Konditionsnummer_103__c=4596; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B111-03B'; obj.Abacus_Konditionsnummer_101__c= 4577; obj.Abacus_Konditionsnummer_102__c= 4557;obj.Abacus_Konditionsnummer_103__c=4597; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B112-03B'; obj.Abacus_Konditionsnummer_101__c= 4578; obj.Abacus_Konditionsnummer_102__c= 4558;obj.Abacus_Konditionsnummer_103__c=4598; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B221-00B'; obj.Abacus_Konditionsnummer_101__c= 4579; obj.Abacus_Konditionsnummer_102__c= 4559;obj.Abacus_Konditionsnummer_103__c=4599; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B222-00B'; obj.Abacus_Konditionsnummer_101__c= 4580; obj.Abacus_Konditionsnummer_102__c= 4560;obj.Abacus_Konditionsnummer_103__c=4600; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B301-00B'; obj.Abacus_Konditionsnummer_101__c= 4581; obj.Abacus_Konditionsnummer_102__c= 4561;obj.Abacus_Konditionsnummer_103__c=4601; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B302-00B'; obj.Abacus_Konditionsnummer_101__c= 4582; obj.Abacus_Konditionsnummer_102__c= 4562;obj.Abacus_Konditionsnummer_103__c=4602; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B311-00B'; obj.Abacus_Konditionsnummer_101__c= 4583; obj.Abacus_Konditionsnummer_102__c= 4563;obj.Abacus_Konditionsnummer_103__c=4603; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B312-00B'; obj.Abacus_Konditionsnummer_101__c= 4584; obj.Abacus_Konditionsnummer_102__c= 4564;obj.Abacus_Konditionsnummer_103__c=4604; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C099-F9P-0'; obj.Abacus_Konditionsnummer_101__c= 4613; obj.Abacus_Konditionsnummer_102__c= 4606;obj.Abacus_Konditionsnummer_103__c=4620; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ZED-F9T-00B'; obj.Abacus_Konditionsnummer_101__c= 4619; obj.Abacus_Konditionsnummer_102__c= 4612;obj.Abacus_Konditionsnummer_103__c=4626; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ODIN-W260-05B'; obj.Abacus_Konditionsnummer_101__c= 4928; obj.Abacus_Konditionsnummer_102__c= 4926;obj.Abacus_Konditionsnummer_103__c=4930; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ODIN-W262-05B'; obj.Abacus_Konditionsnummer_101__c= 4929; obj.Abacus_Konditionsnummer_102__c= 4927;obj.Abacus_Konditionsnummer_103__c=4931; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANN-MB-00'; obj.Abacus_Konditionsnummer_101__c= 5199; obj.Abacus_Konditionsnummer_102__c= 5248;obj.Abacus_Konditionsnummer_103__c=5204; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANN-MB-01'; obj.Abacus_Konditionsnummer_101__c= 5200; obj.Abacus_Konditionsnummer_102__c= 5249;obj.Abacus_Konditionsnummer_103__c=5205; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANN-MB-02'; obj.Abacus_Konditionsnummer_101__c= 5201; obj.Abacus_Konditionsnummer_102__c= 5250;obj.Abacus_Konditionsnummer_103__c=5206; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'RCB-F9T-0'; obj.Abacus_Konditionsnummer_101__c= 5253; obj.Abacus_Konditionsnummer_102__c= 5252;obj.Abacus_Konditionsnummer_103__c=5254; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ANNA-B112-01B'; obj.Abacus_Konditionsnummer_101__c= 5295; obj.Abacus_Konditionsnummer_102__c= 5291;obj.Abacus_Konditionsnummer_103__c=5299; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-ANNA-B112C'; obj.Abacus_Konditionsnummer_101__c= 5296; obj.Abacus_Konditionsnummer_102__c= 5292;obj.Abacus_Konditionsnummer_103__c=5300; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-ANNA-B112U'; obj.Abacus_Konditionsnummer_101__c= 5297; obj.Abacus_Konditionsnummer_102__c= 5293;obj.Abacus_Konditionsnummer_103__c=5301; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B111-04B'; obj.Abacus_Konditionsnummer_101__c= 5298; obj.Abacus_Konditionsnummer_102__c= 5294;obj.Abacus_Konditionsnummer_103__c=5302; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B112-04B'; obj.Abacus_Konditionsnummer_101__c= 5304; obj.Abacus_Konditionsnummer_102__c= 5303;obj.Abacus_Konditionsnummer_103__c=5305; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B306'; obj.Abacus_Konditionsnummer_101__c= 5314; obj.Abacus_Konditionsnummer_102__c= 5308;obj.Abacus_Konditionsnummer_103__c=5320; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'EVK-NINA-B316'; obj.Abacus_Konditionsnummer_101__c= 5315; obj.Abacus_Konditionsnummer_102__c= 5309;obj.Abacus_Konditionsnummer_103__c=5321; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B306-00B'; obj.Abacus_Konditionsnummer_101__c= 5316; obj.Abacus_Konditionsnummer_102__c= 5310;obj.Abacus_Konditionsnummer_103__c=5322; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B311-01B'; obj.Abacus_Konditionsnummer_101__c= 5317; obj.Abacus_Konditionsnummer_102__c= 5311;obj.Abacus_Konditionsnummer_103__c=5323; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B312-01B'; obj.Abacus_Konditionsnummer_101__c= 5318; obj.Abacus_Konditionsnummer_102__c= 5312;obj.Abacus_Konditionsnummer_103__c=5324; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B316-01B'; obj.Abacus_Konditionsnummer_101__c= 5319; obj.Abacus_Konditionsnummer_102__c= 5313;obj.Abacus_Konditionsnummer_103__c=5325; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'SARA-R410M-52B'; obj.Abacus_Konditionsnummer_101__c= 5336; obj.Abacus_Konditionsnummer_102__c= 5334;obj.Abacus_Konditionsnummer_103__c=5338; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R410M-02B'; obj.Abacus_Konditionsnummer_101__c= 5489; obj.Abacus_Konditionsnummer_102__c= 5487;obj.Abacus_Konditionsnummer_103__c=5491; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ADP-R412M-02B'; obj.Abacus_Konditionsnummer_101__c= 5490; obj.Abacus_Konditionsnummer_102__c= 5488;obj.Abacus_Konditionsnummer_103__c=5492; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-W131-01B'; obj.Abacus_Konditionsnummer_101__c= 5495; obj.Abacus_Konditionsnummer_102__c= 5493;obj.Abacus_Konditionsnummer_103__c=5497; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-W132-01B'; obj.Abacus_Konditionsnummer_101__c= 5496; obj.Abacus_Konditionsnummer_102__c= 5494;obj.Abacus_Konditionsnummer_103__c=5498; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C030-R412M-0'; obj.Abacus_Konditionsnummer_101__c= 5500; obj.Abacus_Konditionsnummer_102__c= 5499;obj.Abacus_Konditionsnummer_103__c=5501; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ZED-F9P-01B'; obj.Abacus_Konditionsnummer_101__c= 5504; obj.Abacus_Konditionsnummer_102__c= 5503;obj.Abacus_Konditionsnummer_103__c=5505; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B311-20B'; obj.Abacus_Konditionsnummer_101__c= 5511; obj.Abacus_Konditionsnummer_102__c= 5509;obj.Abacus_Konditionsnummer_103__c=5513; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'NINA-B312-20B'; obj.Abacus_Konditionsnummer_101__c= 5512; obj.Abacus_Konditionsnummer_102__c= 5510;obj.Abacus_Konditionsnummer_103__c=5514; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ODIN-W260-06B'; obj.Abacus_Konditionsnummer_101__c= 5517; obj.Abacus_Konditionsnummer_102__c= 5515;obj.Abacus_Konditionsnummer_103__c=5519; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'ODIN-W262-06B'; obj.Abacus_Konditionsnummer_101__c= 5518; obj.Abacus_Konditionsnummer_102__c= 5516;obj.Abacus_Konditionsnummer_103__c=5520; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C099-F9P-1'; obj.Abacus_Konditionsnummer_101__c= 5523; obj.Abacus_Konditionsnummer_102__c= 5521;obj.Abacus_Konditionsnummer_103__c=5525; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'C099-F9P-2'; obj.Abacus_Konditionsnummer_101__c= 5524; obj.Abacus_Konditionsnummer_102__c= 5522;obj.Abacus_Konditionsnummer_103__c=5526; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-300-A-R'; obj.Abacus_Konditionsnummer_101__c= 5543; obj.Abacus_Konditionsnummer_102__c= 5527;obj.Abacus_Konditionsnummer_103__c=5559; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-300-Eval'; obj.Abacus_Konditionsnummer_101__c= 5544; obj.Abacus_Konditionsnummer_102__c= 5528;obj.Abacus_Konditionsnummer_103__c=5560; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-301-A-R'; obj.Abacus_Konditionsnummer_101__c= 5545; obj.Abacus_Konditionsnummer_102__c= 5529;obj.Abacus_Konditionsnummer_103__c=5561; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-301-Eval'; obj.Abacus_Konditionsnummer_101__c= 5546; obj.Abacus_Konditionsnummer_102__c= 5530;obj.Abacus_Konditionsnummer_103__c=5562; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-330-A-R'; obj.Abacus_Konditionsnummer_101__c= 5547; obj.Abacus_Konditionsnummer_102__c= 5531;obj.Abacus_Konditionsnummer_103__c=5563; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-330-Eval'; obj.Abacus_Konditionsnummer_101__c= 5548; obj.Abacus_Konditionsnummer_102__c= 5532;obj.Abacus_Konditionsnummer_103__c=5564; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-340-A-R'; obj.Abacus_Konditionsnummer_101__c= 5549; obj.Abacus_Konditionsnummer_102__c= 5533;obj.Abacus_Konditionsnummer_103__c=5565; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-340-Eval'; obj.Abacus_Konditionsnummer_101__c= 5550; obj.Abacus_Konditionsnummer_102__c= 5534;obj.Abacus_Konditionsnummer_103__c=5566; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-341-A-R'; obj.Abacus_Konditionsnummer_101__c= 5551; obj.Abacus_Konditionsnummer_102__c= 5535;obj.Abacus_Konditionsnummer_103__c=5567; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-341-Eval'; obj.Abacus_Konditionsnummer_101__c= 5552; obj.Abacus_Konditionsnummer_102__c= 5536;obj.Abacus_Konditionsnummer_103__c=5568; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-350-A-R'; obj.Abacus_Konditionsnummer_101__c= 5554; obj.Abacus_Konditionsnummer_102__c= 5538;obj.Abacus_Konditionsnummer_103__c=5570; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-350-Eval'; obj.Abacus_Konditionsnummer_101__c= 5555; obj.Abacus_Konditionsnummer_102__c= 5539;obj.Abacus_Konditionsnummer_103__c=5571; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-360-A-R'; obj.Abacus_Konditionsnummer_101__c= 5556; obj.Abacus_Konditionsnummer_102__c= 5540;obj.Abacus_Konditionsnummer_103__c=5572; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'BMD-360-Eval'; obj.Abacus_Konditionsnummer_101__c= 5557; obj.Abacus_Konditionsnummer_102__c= 5541;obj.Abacus_Konditionsnummer_103__c=5573; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'R41Z-Eval'; obj.Abacus_Konditionsnummer_101__c= 5577; obj.Abacus_Konditionsnummer_102__c= 5575;obj.Abacus_Konditionsnummer_103__c=5579; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'R41Z-TA-R'; obj.Abacus_Konditionsnummer_101__c= 5578; obj.Abacus_Konditionsnummer_102__c= 5576;obj.Abacus_Konditionsnummer_103__c=5580; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'LARA-R202-82B'; obj.Abacus_Konditionsnummer_101__c= 5583; obj.Abacus_Konditionsnummer_102__c= 5581;obj.Abacus_Konditionsnummer_103__c=5585; data.add(obj);
        obj = new Product2(); obj.ProductCode= 'TOBY-R200-82B'; obj.Abacus_Konditionsnummer_101__c= 5584; obj.Abacus_Konditionsnummer_102__c= 5582;obj.Abacus_Konditionsnummer_103__c=5586; data.add(obj);

        List<String> productCodes = new List<String>();
        for(Product2 currentProduct : data)
        {
              productCodes.add(currentProduct.ProductCode);
        }
       
        
        System.debug('###########################################################################################################');
        System.debug('#'+ data.size());
        
        
        List<Product2> products = [SELECT Id, ProductCode,	Abacus_Konditionsnummer_101__c, Abacus_Konditionsnummer_102__c, Abacus_Konditionsnummer_103__c FROM Product2 WHERE ProductCode IN: productCodes LIMIT 50000];
        System.debug('#'+ products.size());
        Integer counter = 0;
        //if(products.size() >= data.size())
        //{
        
            for(Product2 product : products)
            {
                for(Product2 currentProduct : data)
                {
                    if(product.ProductCode == currentProduct.ProductCode)
                    {
            	        product.Abacus_Konditionsnummer_101__c = currentProduct.Abacus_Konditionsnummer_101__c;
        	            product.Abacus_Konditionsnummer_102__c = currentProduct.Abacus_Konditionsnummer_102__c;
		                product.Abacus_Konditionsnummer_103__c = currentProduct.Abacus_Konditionsnummer_103__c;
                        System.debug('####################################################yes#######################################################');
                        counter++;
                    }
                }
            }
        // }
        
        System.debug('###########################################################################################################');
        System.debug('#'+ data.size());
        System.debug('#'+ products.size());
        System.debug('#updated'+ counter);

		update products;

    }
}