import UIKit

class ExchangeChartView: UIView {
    private var chartLayer: CAShapeLayer?
    private var markerLayers: [CAShapeLayer] = []
    private var verticalLineLayer: CAShapeLayer?
    
    var data: [(Date, Double)] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var onPointSelected: ((Date, Double) -> Void)?
    
    override func draw(_ rect: CGRect) {
        drawChart()
    }
    
    private func drawChart() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        markerLayers.removeAll()
        
        guard !data.isEmpty else { return }
        
        let path = UIBezierPath()
        let maxY = data.map { $0.1 }.max() ?? 0
        let minY = data.map { $0.1 }.min() ?? 0
        let maxX = data.map { $0.0.timeIntervalSince1970 }.max() ?? 0
        let minX = data.map { $0.0.timeIntervalSince1970 }.min() ?? 0
        
        // Chart area
        let chartInsets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        let chartRect = bounds.inset(by: chartInsets)
        
        for (index, dataPoint) in data.enumerated() {
            let x = CGFloat((dataPoint.0.timeIntervalSince1970 - minX) / (maxX - minX)) * chartRect.width + chartRect.minX
            let y = CGFloat(1 - (dataPoint.1 - minY) / (maxY - minY)) * chartRect.height + chartRect.minY
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Add marker for each data point
            let markerLayer = CAShapeLayer()
            markerLayer.path = UIBezierPath(ovalIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)).cgPath
            markerLayer.fillColor = UIColor.white.cgColor
            layer.addSublayer(markerLayer)
            markerLayers.append(markerLayer)
        }
        
        chartLayer = CAShapeLayer()
        chartLayer?.path = path.cgPath
        chartLayer?.strokeColor = UIColor.orange.cgColor
        chartLayer?.fillColor = UIColor.clear.cgColor
        chartLayer?.lineWidth = 2
        
        if let chartLayer = chartLayer {
            layer.addSublayer(chartLayer)
        }
        
        // Add vertical line layer
        verticalLineLayer = CAShapeLayer()
        verticalLineLayer?.strokeColor = UIColor.white.cgColor
        verticalLineLayer?.lineWidth = 1
        verticalLineLayer?.lineDashPattern = [4, 4]
        if let verticalLineLayer = verticalLineLayer {
            layer.addSublayer(verticalLineLayer)
        }
        
        // Add X-axis
        let xAxisLayer = CAShapeLayer()
        let xAxisPath = UIBezierPath()
        xAxisPath.move(to: CGPoint(x: chartRect.minX, y: chartRect.maxY))
        xAxisPath.addLine(to: CGPoint(x: chartRect.maxX, y: chartRect.maxY))
        xAxisLayer.path = xAxisPath.cgPath
        xAxisLayer.strokeColor = UIColor.white.cgColor
        xAxisLayer.lineWidth = 1
        layer.addSublayer(xAxisLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        guard let closestPoint = findClosestPoint(to: location) else { return }
        
        updateVerticalLine(at: closestPoint.x)
        
        if let dataPoint = getDataPoint(for: closestPoint) {
            onPointSelected?(dataPoint.0, dataPoint.1)
        }
    }
    
    private func findClosestPoint(to location: CGPoint) -> CGPoint? {
        let chartInsets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        let chartRect = bounds.inset(by: chartInsets)
        
        let maxX = data.map { $0.0.timeIntervalSince1970 }.max() ?? 0
        let minX = data.map { $0.0.timeIntervalSince1970 }.min() ?? 0
        
        let tappedDate = Date(timeIntervalSince1970: TimeInterval((location.x - chartRect.minX) / chartRect.width) * (maxX - minX) + minX)
        
        let closestDataPoint = data.min { abs($0.0.timeIntervalSince(tappedDate)) < abs($1.0.timeIntervalSince(tappedDate)) }
        
        guard let closestDataPoint = closestDataPoint else { return nil }
        
        let x = CGFloat((closestDataPoint.0.timeIntervalSince1970 - minX) / (maxX - minX)) * chartRect.width + chartRect.minX
        let maxY = data.map { $0.1 }.max() ?? 0
        let minY = data.map { $0.1 }.min() ?? 0
        let y = CGFloat(1 - (closestDataPoint.1 - minY) / (maxY - minY)) * chartRect.height + chartRect.minY
        
        return CGPoint(x: x, y: y)
    }
    
    private func updateVerticalLine(at x: CGFloat) {
        let chartInsets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        let chartRect = bounds.inset(by: chartInsets)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: chartRect.minY))
        path.addLine(to: CGPoint(x: x, y: chartRect.maxY))
        verticalLineLayer?.path = path.cgPath
    }
    
    private func getDataPoint(for point: CGPoint) -> (Date, Double)? {
        let chartInsets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        let chartRect = bounds.inset(by: chartInsets)
        
        let maxX = data.map { $0.0.timeIntervalSince1970 }.max() ?? 0
        let minX = data.map { $0.0.timeIntervalSince1970 }.min() ?? 0
        let date = Date(timeIntervalSince1970: TimeInterval((point.x - chartRect.minX) / chartRect.width) * (maxX - minX) + minX)
        
        return data.first { $0.0 == date }
    }
}
