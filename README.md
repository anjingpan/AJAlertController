# AJAlertController
custom AlertController,Use it just like UIAlertController</br>
<div align = center>
  <img src = "https://github.com/anjingpan/AJAlertController/blob/master/AJAlertController/DemoImage/IMG_3619.PNG" width = "320" height = "500"  />
  <img src = "https://github.com/anjingpan/AJAlertController/blob/master/AJAlertController/DemoImage/IMG_3620.PNG" width = "320" height = "500"  />
  <img src = "https://github.com/anjingpan/AJAlertController/blob/master/AJAlertController/DemoImage/IMG_3621.PNG" width = "320" height = "500"  />
  <img src = "https://github.com/anjingpan/AJAlertController/blob/master/AJAlertController/DemoImage/IMG_3622.PNG" width = "320" height = "500"  />
</div>

# Usage
## Basic
```
    let alert = AJAlertController.init(title: "title", message: "Message", image: #imageLiteral(resourceName: "messi.jpg"), prefferedStyle: .alert)
    let action = AJAlertAction.init(title: "actionTitle", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
```
## Add TextField
If you want to add TextField you just use function **addTextField**
```
        let alert = AJAlertController.init(title: "title", message: "Message", image: #imageLiteral(resourceName: "messi.jpg"), prefferedStyle: .alert)
        alert.addTextField { (textField) in
        }
        
        alert.addTextField { (textField) in
        }
        
        let confirm = AJAlertAction.init(title: "confirm", style: .default) {
            
        }

        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
 ```
