import Scenes
import Igis
import Foundation

  /*
     This class is responsible for rendering the background.
   */
let CS = 4*9
let X = 115
let Y = 212

class Background : RenderableEntity {

    let hitCircle : Image
    
    init() {
        guard let hitCirclePNG = URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/US-WhiteHouse-Logo.svg/2000px-US-WhiteHouse-Logo.svg.png") else {
            fatalError("Failed to create URL for whitehouse")

            // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")
    }
    override func setup(canvasSize:Size, canvas:Canvas) {
 

        
//circle code

        /*
        let lineWidth = LineWidth(width:5)
        canvas.render(lineWidth)  

        let red = StrokeStyle(color:Color(.red))
        canvas.render(red)

        let ellipse = Ellipse(center:Point(x:X, y:Y), radiusX:CS, radiusY:CS)
        canvas.render(ellipse)
         */
    }
}
