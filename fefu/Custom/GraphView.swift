//
//  GraphView.swift
//  FefA
//
//  Created by Вадим Семибратов on 30.11.2024.
//
import UIKit

class GraphView: UIView {
    
    private var activitiesData: [(date: String, distance: Double, time: Double)] = []
    
    func setData(_ data: [(date: String, distance: Double, time: Double)]) {
        self.activitiesData = data
        self.setNeedsDisplay() // Trigger a redraw
    }
    
    override func draw(_ rect: CGRect) {
        guard !activitiesData.isEmpty else { return }

        let context = UIGraphicsGetCurrentContext()
        let width = rect.width
        let height = rect.height

        // Set the background to white
        UIColor.white.setFill()
        context?.fill(rect)

        // Graph margins and settings
        let margin: CGFloat = 40 // Reduced margin
        let graphWidth = width - 2 * margin
        let graphHeight = height - 2 * margin
        let maxDistance = activitiesData.map { $0.distance }.max() ?? 1.0

        // Validate maxDistance to prevent division by zero
        if maxDistance == 0 {
            print("Invalid maxDistance: 0. Graph cannot be drawn.")
            return
        }

        // Colors
        let axisColor = UIColor.lightGray.cgColor
        let pointColor = UIColor.red.cgColor

        // Set axis line width and color
        context?.setStrokeColor(axisColor)
        context?.setLineWidth(1)

        // Y-Axis (Left vertical axis)
        context?.move(to: CGPoint(x: margin, y: margin))
        context?.addLine(to: CGPoint(x: margin, y: height - margin))
        context?.strokePath()

        // X-Axis (Bottom horizontal axis)
        context?.move(to: CGPoint(x: margin, y: height - margin))
        context?.addLine(to: CGPoint(x: width - margin, y: height - margin))
        context?.strokePath()

        // Gradient setup for the area below the curve
        let gradientColors: [CGColor] = [
            UIColor.red.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor
        ]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: [0.0, 1.0])!

        // Reduce the spacing between the points
        let pointSpacing = graphWidth / CGFloat(activitiesData.count) // Reduced spacing
        
        var points: [CGPoint] = []

        // Draw the graph line and collect points
        for (index, data) in activitiesData.enumerated() {
            let x = margin + CGFloat(index) * pointSpacing
            let y = height - margin - CGFloat(data.distance / maxDistance) * graphHeight

            // Ensure y is valid (not NaN) and within bounds
            if y.isNaN || y < margin || y > height - margin {
                print("Invalid Y position for point at index \(index), skipping point.")
                continue
            }

            points.append(CGPoint(x: x, y: y)) // Collect points for the polygon
            
            // Draw point (red circle) on top of the graph
            context?.setFillColor(pointColor)
            context?.fillEllipse(in: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
        }

        // Now, we need to fill the area between the curve and the x-axis with the gradient
        context?.beginPath()
        context?.move(to: CGPoint(x: points.first!.x, y: height - margin))

        // Draw the path along the points
        for point in points {
            context?.addLine(to: point)
        }

        // Close the path and fill with gradient
        context?.addLine(to: CGPoint(x: points.last!.x, y: height - margin))
        context?.closePath()

        context?.saveGState()

        // Clip the context to the area below the line
        context?.clip()

        // Draw the vertical gradient inside the clipped path
        context?.drawLinearGradient(gradient,
                                    start: CGPoint(x: points.first!.x, y: height - margin),
                                    end: CGPoint(x: points.first!.x, y: points.last!.y),
                                    options: .drawsBeforeStartLocation)

        context?.restoreGState()

        // Stroke the path (the connecting lines between points)
        context?.setStrokeColor(UIColor.orange.cgColor)
        context?.setLineWidth(2)
        context?.strokePath()

        // Draw the Y-Axis labels (distance)
        let yInterval = maxDistance / 5
        let yLabelFormatter = NumberFormatter()
        yLabelFormatter.maximumFractionDigits = 2

        for i in 0..<6 {
            let yValue = yInterval * Double(i)
            let y = height - margin - CGFloat(yValue / maxDistance) * graphHeight

            // Convert to kilometers if greater than 1000 meters
            let yValueInKm = yValue >= 1000 ? yValue / 1000 : yValue

            let labelText = yValueInKm >= 1.0 ? String(format: "%.2f км", yValueInKm / 1000) : String(format: "%.0f м", yValue)

            // Ensure y position is valid and within bounds
            if y.isNaN || y < margin || y > height - margin {
                print("Invalid Y position for label \(labelText), skipping label.")
                continue
            }

            let label = UILabel()
            label.text = labelText
            label.font = UIFont.systemFont(ofSize: 10)
            label.sizeToFit()

            // Ensure label position is valid (x and y)
            let labelX = margin - label.frame.width - 5
            let labelY = y - label.frame.height / 2
            
            // Skip label if positions are invalid (NaN) or out of bounds
            if labelX.isNaN || labelY.isNaN || labelY < margin || labelY > height - margin {
                print("Skipping label with invalid position.")
                continue
            }

            label.frame.origin = CGPoint(x: labelX, y: labelY)
            label.textColor = .black
            self.addSubview(label) // Add label to the view
        }

        // Add vertical gridlines (gray lines dividing sections)
        let numberOfSections = 3 // Reduced number of sections
        let sectionWidth = graphWidth / CGFloat(numberOfSections)

        context?.setStrokeColor(UIColor.lightGray.cgColor)
        context?.setLineWidth(0.5)

        for i in 1..<numberOfSections {
            let x = margin + CGFloat(i) * sectionWidth
            context?.move(to: CGPoint(x: x, y: margin))
            context?.addLine(to: CGPoint(x: x, y: height - margin))
            context?.strokePath()
        }

        // Draw labels for months on the X-Axis
        var lastMonth: String?
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"

        for (index, data) in activitiesData.enumerated() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: data.date) {
                let month = monthFormatter.string(from: date)

                // Only draw the label if the month is different from the previous one
                if month != lastMonth {
                    let x = margin + CGFloat(index) * pointSpacing
                    let label = UILabel()
                    label.text = month
                    label.font = UIFont.systemFont(ofSize: 10)
                    label.sizeToFit()

                    // Set label position just below the X-Axis
                    let labelX = x - label.frame.width / 2
                    let labelY = height - margin + 5
                    
                    // Skip label if position is invalid or out of bounds
                    if labelX.isNaN || labelY.isNaN || labelY > height - margin {
                        print("Skipping label with invalid position.")
                        continue
                    }

                    label.frame.origin = CGPoint(x: labelX, y: labelY)
                    label.textColor = .black

                    self.addSubview(label) // Add label to the view

                    // Update the last month for comparison
                    lastMonth = month
                }
            }
        }
    }
}
