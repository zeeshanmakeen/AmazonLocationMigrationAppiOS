//
//  ViewController.swift
//  AmazonMigrationApp
//
//  Created by Zeeshan Sheikh on 21/11/2023.
//

import UIKit
import Mapbox
import AWSLocationXCF

class ViewController: UIViewController, MGLMapViewDelegate {

    let apiKey = "v1.public.eyJqdGkiOiIwYjgwOTcyZC1lZmFlLTQwZTMtODE1MS01N2QyYjliYTdlM2MifUuoYYLrXgQbEB_whcmqolAq348iEM0RXu5PZtEzrB0nKCHvlQF9yM-Q0nwb3EwW_igoqnUy3NIORr9osmGC5WR4OqehLKSxeBHbZHI0A2f6pK9CdrezSc-wKrHyyfNipzTVyS-iVEqYQZGGT3RL2DMw7dygkhoCREbDRIPX44bwDPDYBWpvQ6chS94nhZi2uByn42uLbTdhe7cBuKPw8ZcxSqg3QoOC1-FbvIel2qQXjW31A4RtzTfaLnHJP5xUNeol6XCxqJlggGNQyKMa8UD17D9Ck4JbOPGh62QfAeOOAC99TAL23t6sILCtx1nXsZKYUW7HiHTJXcROgialcls.ZWU0ZWIzMTktMWRhNi00Mzg0LTllMzYtNzlmMDU3MjRmYTkx"
    let mapName = "explore.map.Esri"
    let regionName = "us-east-1"
    private var mapView: MGLMapView?
    private var searchTableView: UITableView?
    var searchResults: [String] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let searchTextField = UITextField(frame: CGRect(x: 20, y: 80, width: self.view.frame.size.width - 40, height: 40))
        searchTextField.placeholder = "Search places"
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
        //view.addSubview(searchTextField)
        
        searchTableView = UITableView(frame:CGRect(x: 20, y: searchTextField.frame.maxY+10, width: self.view.frame.size.width - 40, height: view.bounds.height))
        searchTableView?.dataSource = self
        searchTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //view.addSubview(searchTableView!)
        
        let routeButton = UIButton(frame: CGRect(x: 20, y: 80, width: 150, height: 30))
        routeButton.setTitle("Calculte Route", for: .normal)
        routeButton.backgroundColor = .black
        routeButton.addTarget(self, action: #selector(showRoute), for: .touchUpInside)
        //view.addSubview(routeButton)

        let region = (regionName as NSString).aws_regionTypeValue()
        let styleURL = URL(string: "https://maps.geo.\(regionName).amazonaws.com/maps/v0/maps/\(mapName)/style-descriptor?key=\(apiKey)")
 
        mapView = MGLMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), styleURL: styleURL)
        //mapView = MGLMapView(frame: CGRect(x: 0, y: routeButton.frame.maxY+10, width: view.bounds.width, height: view.bounds.height - routeButton.frame.maxY), styleURL: styleURL)
        mapView?.delegate = self
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView?.setCenter(CLLocationCoordinate2D(latitude: 49.246559, longitude: -123.063554), zoomLevel: 10, animated: false)
        view.addSubview(mapView!)
        
        //initializeAWSConfiguration(region: region, identityPoolID: identityPoolID)
    }
    
    func initializeAWSConfiguration(region: AWSRegionType, identityPoolID: String) {
    
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: identityPoolID)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        if(fullyRendered) {
            print("Map and style have finished rendering")
            //addMarker()
            //addMarkerWithInfo()
            //addPolyline()
            //addPolygon()
            addMarkerClustering()
            //addHeatMap()
            //setMapViewBounds()
            //drawCircle()
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func addMarker() {
        let coordinates = CLLocationCoordinate2D(latitude: 49.246559, longitude: -123.063554)
        mapView?.setCenter(coordinates, zoomLevel: 10, animated: false)
        
        let point = MGLPointAnnotation()
        point.coordinate = coordinates
        mapView?.addAnnotation(point)
    }
    
    func addMarkerWithInfo() {
        let coordinates = CLLocationCoordinate2D(latitude: 37.8, longitude: -96)
        mapView?.setCenter(coordinates, zoomLevel: 2, animated: false)
        
        let point = MGLPointAnnotation()
        point.coordinate = coordinates
        point.title = "Hello World"
        mapView?.addAnnotation(point)
        mapView?.selectAnnotation(point, animated: true)
    }
    
    func addPolyline() {
        
        mapView?.setCenter(CLLocationCoordinate2D(latitude: 37.830348, longitude: -122.486052), zoomLevel: 15, animated: true)

        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.83381888486939, longitude: -122.48369693756104),
            CLLocationCoordinate2D(latitude: 37.83317489144141, longitude: -122.48348236083984),
            CLLocationCoordinate2D(latitude: 37.83270036637107, longitude: -122.48339653015138),
            CLLocationCoordinate2D(latitude: 37.832056363179625, longitude: -122.48356819152832),
            CLLocationCoordinate2D(latitude: 37.83114119107971, longitude: -122.48404026031496),
            CLLocationCoordinate2D(latitude: 37.83049717427869, longitude: -122.48404026031496),
            CLLocationCoordinate2D(latitude: 37.829920943955045, longitude: -122.48348236083984),
            CLLocationCoordinate2D(latitude: 37.82954808664175, longitude: -122.48356819152832),
            CLLocationCoordinate2D(latitude: 37.82944639795659, longitude: -122.48507022857666),
            CLLocationCoordinate2D(latitude: 37.82880236636284, longitude: -122.48610019683838),
        ]

        let polyline = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))

        mapView?.addAnnotation(polyline)
    }
    
    func addPolygon() {
        mapView?.setCenter(CLLocationCoordinate2D(latitude: 24.886, longitude: -70.268), zoomLevel: 3, animated: true)
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: 25.774, longitude: -80.19),
            CLLocationCoordinate2D(latitude: 18.466, longitude: -66.118),
            CLLocationCoordinate2D(latitude: 32.321, longitude: -64.757),
            CLLocationCoordinate2D(latitude: 25.774, longitude: -80.19),
        ]

        let polygon = MGLPolygon(coordinates: coordinates, count: UInt(coordinates.count))

        mapView?.addAnnotation(polygon)
    }
    
    func addMarkerClustering() {
        mapView?.setCenter(CLLocationCoordinate2D(latitude: 47.6101, longitude: -122.2015), zoomLevel: 10, animated: true)
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: 47.6545, longitude: -122.3586),
            CLLocationCoordinate2D(latitude: 47.6101, longitude: -122.2015),
            CLLocationCoordinate2D(latitude: 47.6740, longitude: -122.1215)
        ]
        
        let pointFeatures = coordinates.map { coordinate -> MGLPointFeature in
            let pointFeature = MGLPointFeature()
            pointFeature.coordinate = coordinate
            return pointFeature
        }
        
        let shapeCollectionFeature = MGLShapeCollectionFeature(shapes: pointFeatures)
        let source = MGLShapeSource(identifier: "clusteredPorts", shape: shapeCollectionFeature, options: [.clustered: true, .clusterRadius: 20])
        mapView?.style?.addSource(source)
        
        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPortsCircles", source: source)
        circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: Double(20)))
        circlesLayer.circleColor = NSExpression(forConstantValue: UIColor.blue)
        circlesLayer.circleOpacity = NSExpression(forConstantValue: NSNumber(value: 0.8))
        mapView?.style?.addLayer(circlesLayer)
    }
    
    func addMarkerClustering2() {
        mapView?.setCenter(CLLocationCoordinate2D(latitude: 47.6101, longitude: -122.2015), zoomLevel: 10, animated: true)
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: 47.6545, longitude: -122.3586),
            CLLocationCoordinate2D(latitude: 47.6101, longitude: -122.2015),
            CLLocationCoordinate2D(latitude: 47.6740, longitude: -122.1215)
        ]
        
        let pointFeatures = coordinates.map { coordinate -> MGLPointFeature in
            let pointFeature = MGLPointFeature()
            pointFeature.coordinate = coordinate
            return pointFeature
        }
        
        // Create a shape collection feature with the point features.
        let shapeCollectionFeature = MGLShapeCollectionFeature(shapes: pointFeatures)

        // Create a source and add it to the map style.
        let source = MGLShapeSource(identifier: "clusteredPorts", shape: shapeCollectionFeature, options: [.clustered: true, .clusterRadius: 20])
        mapView?.style?.addSource(source)
        
        // Create a layer for the clusters.
        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPortsCircles", source: source)

        // Set the circle radius and color based on the point_count key path.
        circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: Double(20)))
        circlesLayer.circleColor = NSExpression(forConstantValue: UIColor.blue)

        // Add the layer to the map style.
        mapView?.style?.addLayer(circlesLayer)

        // Create a layer for the cluster labels.
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)

        // Set the label's expression to point_count.
        numbersLayer.text = NSExpression(forKeyPath: "point_count")

        // Style the labels.
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(12)))

        // Add the layer to the map style.
        mapView?.style?.addLayer(numbersLayer)
    }
    
    func addMarkerClustering1() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 47.6545, longitude: -122.3586),
            CLLocationCoordinate2D(latitude: 47.6101, longitude: -122.2015),
            CLLocationCoordinate2D(latitude: 47.6740, longitude: -122.1215)
        ]
        
        let pointFeatures = coordinates.map { coordinate -> MGLPointFeature in
            let pointFeature = MGLPointFeature()
            pointFeature.coordinate = coordinate
            return pointFeature
        }
        
        // Create a shape collection feature with the point features.
        let shapeCollectionFeature = MGLShapeCollectionFeature(shapes: pointFeatures)
        
        // Create a source and add it to the map style.
        let source = MGLShapeSource(identifier: "clusteredPorts", shape: shapeCollectionFeature, options: [.clustered: true, .clusterRadius: 20])
        mapView?.style?.addSource(source)
        
        // Create a layer for the clusters.
        let circlesLayer = MGLCircleStyleLayer(identifier: "clusteredPortsCircles", source: source)

        // Set the circle radius and color based on the point_count key path.
        circlesLayer.circleRadius = NSExpression(forConstantValue: NSNumber(value: Double(20)))
        circlesLayer.circleColor = NSExpression(forConstantValue: UIColor.red)

        // Add the layer to the map style.
        mapView?.style?.addLayer(circlesLayer)

        // Create a layer for the cluster labels.
        let numbersLayer = MGLSymbolStyleLayer(identifier: "clusteredPortsNumbers", source: source)

        // Set the label's expression to point_count.
        numbersLayer.text = NSExpression(forKeyPath: "point_count")

        // Style the labels.
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.textFontSize = NSExpression(forConstantValue: NSNumber(value: Double(12)))

        // Add the layer to the map style.
        mapView?.style?.addLayer(numbersLayer)
    }
    
    func createMGLPointFeature(coordinate: CLLocationCoordinate2D, mag: Double) -> MGLPointFeature {
        let feature = MGLPointFeature()
        feature.coordinate = coordinate
        feature.attributes = ["mag": mag]
        return feature
    }
    
    func addHeatMap() {
        mapView?.setCenter(CLLocationCoordinate2D(latitude: 37.79172786767758, longitude: -122.4190838170745), zoomLevel: 12, animated: true)
        
        // Create point features for your coordinates.
        var features:[MGLFeature & MGLShape] = []
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.782551, longitude: -122.445368), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.782745, longitude: -122.444586), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.782842, longitude: -122.443688), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.782919, longitude: -122.442815), mag: 2.4))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.782992, longitude: -122.442112), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.7831, longitude: -122.441461), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.783206, longitude: -122.440829), mag: 4.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.783273, longitude: -122.440324), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.783316, longitude: -122.440023), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.783357, longitude: -122.439794), mag: 2.2))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.78501, longitude: -122.439947), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.78536, longitude: -122.439952), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.785715, longitude: -122.44003), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.786117, longitude: -122.440119), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.786564, longitude: -122.440209), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.786905, longitude: -122.44027), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.786956, longitude: -122.440279), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800224, longitude: -122.43352), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800155, longitude: -122.434101), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.80016, longitude: -122.43443), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800661, longitude: -122.436273), mag: 3.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800395, longitude: -122.436172), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800228, longitude: -122.436116), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800169, longitude: -122.43613), mag: 1.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.800066, longitude: -122.436167), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.784345, longitude: -122.422922), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.784389, longitude: -122.422926), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.784437, longitude: -122.422924), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.784746, longitude: -122.422818), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.785436, longitude: -122.422959), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.787217, longitude: -122.416715), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.786144, longitude: -122.416403), mag: 3.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.785292, longitude: -122.416257), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.780666, longitude: -122.390374), mag: 1.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.780501, longitude: -122.391281), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.780148, longitude: -122.392052), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.780173, longitude: -122.391148), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.780693, longitude: -122.390592), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.781261, longitude: -122.391142), mag: 2.8))
        features.append(createMGLPointFeature(coordinate:CLLocationCoordinate2D(latitude:37.781808, longitude: -122.39173), mag: 2.8))

        // Create a shape collection feature from your features.
        let shapeCollectionFeature = MGLShapeCollectionFeature(shapes: features)

        // Create a shape source with your shape collection feature.
        let source = MGLShapeSource(identifier: "earthquakes", shape: shapeCollectionFeature, options: nil)

        // Add the source to the map
        mapView?.style?.addSource(source)

        // Create the heatmap layer
        let heatmapLayer = MGLHeatmapStyleLayer(identifier: "earthquakes", source: source)

        // Customize the appearance of the heatmap
        heatmapLayer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(magnitude, 'linear', nil, %@)",
                                       [0: 0,
                                        2: 1])
        heatmapLayer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                          [0: 1,
                                           6: 3])
        
        heatmapLayer.heatmapRadius = NSExpression(forConstantValue: 10)

        // Add the heatmap layer to the map
        mapView?.style?.addLayer(heatmapLayer)
    }
        
    func addHeatMap1() {
        // Define the coordinates for your points.
        
        let seattleCoordinates = CLLocationCoordinate2D(latitude: 47.654502614244194, longitude: -122.35862564621954)
        let bellevueCoordinates = CLLocationCoordinate2D(latitude: 47.6101, longitude: -122.2015)
        let redmondCoordinates = CLLocationCoordinate2D(latitude: 47.6740, longitude: -122.1215)

        // Create point features for your coordinates.
        let seattleFeature = MGLPointFeature()
        seattleFeature.coordinate = seattleCoordinates
        seattleFeature.attributes = ["mag": 2.8]

        let bellevueFeature = MGLPointFeature()
        bellevueFeature.coordinate = bellevueCoordinates
        bellevueFeature.attributes = ["mag": 3.1]

        let redmondFeature = MGLPointFeature()
        redmondFeature.coordinate = redmondCoordinates
        redmondFeature.attributes = ["mag": 3.3]

        // Add your features to an array.
        var features:[MGLFeature & MGLShape] = []
        features.append(createMGLPointFeature(coordinate: CLLocationCoordinate2D(latitude:37.782551, longitude: -122.445368), mag: 2.8))

        // Create a shape collection feature from your features.
        let shapeCollectionFeature = MGLShapeCollectionFeature(shapes: features)

        // Create a shape source with your shape collection feature.
        let source = MGLShapeSource(identifier: "earthquakes", shape: shapeCollectionFeature, options: nil)

        // Add the source to the map
        mapView?.style?.addSource(source)

        // Create the heatmap layer
        let heatmapLayer = MGLHeatmapStyleLayer(identifier: "earthquakes", source: source)

        // Customize the appearance of the heatmap
        heatmapLayer.heatmapWeight = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:(magnitude, 'linear', nil, %@)",
                                       [0: 0,
                                        6: 1])
        heatmapLayer.heatmapIntensity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                          [0: 1,
                                           9: 3])

        // Add the heatmap layer to the map
        mapView?.style?.addLayer(heatmapLayer)
    }
    
    func setMapViewBounds() {
        // Define the corners of the bounding box covering the USA.
        let ne = CLLocationCoordinate2D(latitude: 49.384358, longitude: -66.934570) // Northeast corner
        let sw = CLLocationCoordinate2D(latitude: 24.396308, longitude: -125.001650) // Southwest corner

        // Create a MGLCoordinateBounds from those corners.
        let usaBounds = MGLCoordinateBounds(sw: sw, ne: ne)

        // Set the map view's visible bounds to the USA.
        mapView?.setVisibleCoordinateBounds(usaBounds, animated: true)
    }
    
   @objc func showRoute() {
        let departurePosition = CLLocationCoordinate2D(latitude: 47.654502614244194, longitude: -122.35862564621954)
        let destinationPosition = CLLocationCoordinate2D(latitude: 47.622177342594995, longitude: -122.33463997279051)
//        calculateRoute(depaturePosition: departurePosition, destinationPosition: destinationPosition, travelMode: .car, avoidFerries: false, avoidTolls: false, completion: {response in
//            switch response {
//            case .success(let result):
//                print("Route calculated: \(result)")
//                self.drawRoute(result: result)
//            case .failure(let error):
//                print("Route calculation failed: \(error)")
//            }
//        })
       
       calculateRoute2(depaturePosition: departurePosition, destinationPosition: destinationPosition, travelMode: .car, avoidFerries: false, avoidTolls: false, completion: {response in
           switch response {
           case .success(let result):
               print("Route calculated: \(result)")
               //self.drawRoute(result: result)
           case .failure(let error):
               print("Route calculation failed: \(error)")
           }
       })
    }
    
    func drawRoute(result: AWSLocationCalculateRouteResponse) {
        var coordinates = [CLLocationCoordinate2D]()
        
        // Parse the route from the response
        // This is a simplified example, you may need to adjust this based on the actual structure of your response
        for leg in result.legs! {
            for step in leg.steps! {
                coordinates.append(CLLocationCoordinate2D(latitude: step.startPosition!.last!.doubleValue, longitude: step.endPosition!.first!.doubleValue))
            }
        }
        
        // Create a polyline and add it to the map
        let polyline = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        mapView?.addAnnotation(polyline)
    }
    
    func calculateRoute(depaturePosition: CLLocationCoordinate2D,
        destinationPosition: CLLocationCoordinate2D,
        travelMode: AWSLocationTravelMode,
        avoidFerries: Bool,
        avoidTolls: Bool,
        completion: @escaping ((Result<AWSLocationCalculateRouteResponse, Error>) -> Void)) {
        
        let request = AWSLocationCalculateRouteRequest()!
        request.departNow = true
        request.travelMode = travelMode
        request.calculatorName = "EsriRouteCalculator"
        request.includeLegGeometry = true
        if travelMode == .car {
        let carModeOptions = AWSLocationCalculateRouteCarModeOptions()
        carModeOptions?.avoidTolls = NSNumber(booleanLiteral: avoidTolls)
        carModeOptions?.avoidFerries = NSNumber(booleanLiteral: avoidFerries)
        request.carModeOptions = carModeOptions
        }
        request.departurePosition = [NSNumber(value: depaturePosition.longitude), NSNumber(value: depaturePosition.latitude)]
        request.destinationPosition = [NSNumber(value: destinationPosition.longitude), NSNumber(value: destinationPosition.latitude)]
        
        AWSLocation.default().calculateRoute(request) { (response, error) in
            if let taskResult = response {
            completion(.success(taskResult))
            } else {
            let defaultError = NSError(domain: "Routing", code: -1)
            let error = error ?? defaultError
            print("error \(error)")
            completion(.failure(error))
            }
        }
    }
    
    func calculateRoute2(depaturePosition: CLLocationCoordinate2D,
                         destinationPosition: CLLocationCoordinate2D,
                         travelMode: AWSLocationTravelMode,
                         avoidFerries: Bool,
                         avoidTolls: Bool,
                         completion: @escaping ((Result<Any, Error>) -> Void)) {
        let routeCalculatorName = "explore.route-calculator.Esri"
        let url = URL(string: "https://maps.geo.\(regionName).amazonaws.com/routes/v0/calculators/\(routeCalculatorName)/calculate/route?key=\(apiKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "X-Amz-Security-Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add your request body here
        let requestBody: [String: Any] = [
            "departurePosition": [depaturePosition.longitude, depaturePosition.latitude],
            "destinationPosition": [destinationPosition.longitude, destinationPosition.latitude],
            // Add other parameters as needed
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)

        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON: \(json)")
                    completion(.success(json))
                } catch {
                    print("Error parsing JSON: \(error)")
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    
    func searchTextRequest(text: String,
        userLat: Double?,
        userLong: Double?,
        completion: @escaping ([AWSLocationSearchForTextResult]?) -> Void ) {
        
        let request = AWSLocationSearchPlaceIndexForTextRequest()!
        request.language = String((Locale.preferredLanguages.first ?? Locale.current.identifier).prefix(2))
        request.text = text
        request.indexName = "explore.place.Esri"
        if let lat = userLat, let long = userLong {
        let biasPosition = [NSNumber(value: long), NSNumber(value: lat)]
        request.biasPosition = biasPosition
        }
        
        AWSLocation.default().searchPlaceIndex(forText: request) { (response, error) in
            if let error = error {
            print("error \(error)")
            } else if let taskResult = response,
            let searchResult = taskResult.results {
            completion(searchResult)
            }
        }
    }
    
    func drawCircle() {
        let center = CLLocationCoordinate2D(latitude: 49.257387256602755, longitude: -123.11845533871497)
        mapView?.setCenter(center, zoomLevel: 11, animated: true)
        
        // Create a point annotation and add it to circle layer
        let annotation = MGLPointAnnotation()
        annotation.coordinate = center
        let source =  MGLShapeSource(identifier: "circle-source", shape: annotation, options: nil)
        mapView?.style?.addSource(source)
        
        let layer = MGLCircleStyleLayer(identifier: "circle-layer", source: source)
        // Set the circle color and radius
        layer.circleColor = NSExpression(forConstantValue: UIColor.red)
        layer.circleRadius = NSExpression(forConstantValue: NSNumber(value: 150))
        layer.circleOpacity = NSExpression(forConstantValue: NSNumber(value: 0.5))
        layer.circleStrokeColor = NSExpression(forConstantValue: UIColor.red)
        layer.circleStrokeWidth = NSExpression(forConstantValue: NSNumber(value: 2))
            
        mapView?.style?.addLayer(layer)
    }
}

extension ViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // Now you have the updated text

        if updatedText.count > 2 {
            searchTextRequest(text: updatedText, userLat: 47.654502614244194, userLong: -122.35862564621954) { results in
                // Handle the search results here
                self.searchResults = []
                for item in results! {
                    self.searchResults.append((item.place?.label)!)
                }
                DispatchQueue.main.async {
                    self.searchTableView?.reloadData()
                }
            }
        }
        return true
    }
}

