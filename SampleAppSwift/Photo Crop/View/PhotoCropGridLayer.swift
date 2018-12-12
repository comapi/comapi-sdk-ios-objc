//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

class PhotoCropGridLayer: CAShapeLayer {
    
    var gridSize: CGSize

    init(size: CGSize) {
        gridSize = CGSize(width: round(size.width), height: round(size.height))
        
        super.init()
        
        drawGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGrid() {
        let xSpacing = gridSize.width / 3
        let ySpacing = gridSize.height / 3
        
        let startingPoints = [[CGPoint(x: xSpacing, y: 0), CGPoint(x: xSpacing * 2, y: 0)],
                              [CGPoint(x: 0, y: ySpacing), CGPoint(x: 0, y: ySpacing * 2)]]
        let endingPoints = [[CGPoint(x: xSpacing, y: gridSize.height), CGPoint(x: xSpacing * 2, y: gridSize.height)],
                            [CGPoint(x: gridSize.width, y: ySpacing), CGPoint(x: gridSize.width, y: ySpacing * 2)]]
        let path = CGMutablePath()
        path.move(to: startingPoints[0][0])
        path.addLine(to: endingPoints[0][0])
        
        path.move(to: startingPoints[0][1])
        path.addLine(to: endingPoints[0][1])
        
        path.move(to: startingPoints[1][0])
        path.addLine(to: endingPoints[1][0])
        
        path.move(to: startingPoints[1][1])
        path.addLine(to: endingPoints[1][1])
        
        strokeColor = UIColor.white.cgColor
        lineWidth = 1.0
        needsDisplayOnBoundsChange = true
        
        path.closeSubpath()
        
        self.path = path
    }
}
