//
//  MainViewController.swift
//  shoppingCart
//
//  Created by Ken on 2020/5/6.
//  Copyright © 2020 罗连喜. All rights reserved.
//

import UIKit
import SnapKit
//屏幕的size
//let screenmainSize = UIScreen.main.bounds.size

class MainViewController: UIViewController,CAAnimationDelegate,UITableViewDelegate,UITableViewDataSource,MainToTableViewCellDelegate{
    
    

    fileprivate var goodListArray = [AJGoodModel]()
    fileprivate let goodResuceCell = "cell"
    fileprivate var addGoodList = [AJGoodModel]()
    var layer : CALayer?
    fileprivate var pathone : UIBezierPath?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        layoutUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        loadUI()
        // Do any additional setup after loading the view.
    }
    
    func loadUI(){
        
        navigationItem.title = "测试商城标题"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button_two)
//        let btnone = UIBarButtonItem.init(customView: button_shop)
//        let btntwo = UIBarButtonItem.init(customView: button_two)
//        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action:nil)
//        space.width = 5
//        navigationItem.rightBarButtonItems = [btntwo]
        navigationController?.navigationBar.addSubview(amoutCart)
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(carTableView)
        carTableView.register(MainTableViewCell.self , forCellReuseIdentifier: goodResuceCell)
        
    }
    
    func initData() {
        
        for i in 0..<10 {
            
            var dic = [String:AnyObject]()
            dic["title"] = "\(i)commite" as AnyObject
            dic["iconName"] = "goodicon_\(i)" as AnyObject
            dic["desc"] = "这是第\(i)个商品" as AnyObject
            dic["newPrice"] = "20\(i)" as AnyObject
            dic["oldPrice"] = "30\(i)" as AnyObject
            
            let good:AJGoodModel = AJGoodModel.init(dict: dic)
            goodListArray.append(good)
        }
    }
   
    
    
    // MARK: - 加载 约束
    func layoutUI() -> Void {
        
        amoutCart.snp_makeConstraints { (make) in
            make.right.equalTo(-12)
            make.top.equalTo(10.5)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
    }
    
    lazy var carTableView : UITableView = {
       var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        return tableView;
    }()

    // MARK: -
    lazy var amoutCart : UILabel = {
        var lable = UILabel()
        lable.textColor = UIColor.red
        lable.backgroundColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 11)
        lable.text = "22"
        lable.textAlignment = NSTextAlignment.center
        lable.layer.cornerRadius = 7.5
        lable.layer.masksToBounds = true
        lable.layer.borderColor = UIColor.red.cgColor
        lable.layer.borderWidth = 1
        lable.isHidden = true
        return lable
    }()
    
    
    lazy var button_shop : UIButton = {
        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 100))
        btn.setImage(UIImage(named: "button_cart"), for: .normal)
        btn.addTarget(self, action: #selector(shopClick), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 80)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0,0)
        return btn
    }()
    lazy var button_two : UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "button_cart"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(shopClick), for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    @objc func shopClick(){
        print("我被点击了")
        let controller = AJShoppingViewController()
        controller.addGoodArray = addGoodList
        navigationController?.present(UINavigationController(rootViewController: controller), animated: true, completion: {
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MainViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MainTableViewCell = tableView.dequeueReusableCell(withIdentifier:goodResuceCell , for: indexPath) as! MainTableViewCell
        cell.goodModel = goodListArray[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
}


extension MainViewController{

    // MARK: - 加入购物车之后 核心动画
    func clickTransmitData(cell: MainTableViewCell, icon: UIImageView) {
        guard let indexPath = carTableView.indexPath(for: cell) else {
            return
        }
        let data = goodListArray[indexPath.row];
        addGoodList.append(data);
        amoutCart.text = "\(addGoodList.count)"
        amoutCart.isHidden = false
        var rect = carTableView.rectForRow(at: indexPath)
         print("位置  %d--------",rect.origin.y )
        rect.origin.y -= carTableView.contentOffset.y
        print("位置减去偏移量  %d--------",rect.origin.y )
        var HeadReact = icon.frame
        HeadReact.origin.y = HeadReact.origin.y + rect.origin.y - 64
        print("位置  %d--------y:   %d", HeadReact.origin.y,rect.origin.y )

        layer = CALayer()
        layer?.contents = icon.layer.contents
        layer?.bounds = HeadReact
        layer?.contentsGravity = kCAGravityResizeAspectFill
        layer?.cornerRadius = layer!.bounds.height * 0.5
        layer?.masksToBounds = true
        layer?.position = CGPoint(x: icon.center.x, y: HeadReact.maxY)
        UIApplication.shared.keyWindow?.layer.addSublayer(layer!)
        pathone = UIBezierPath()
        //去设置起始坐标
        pathone?.move(to:CGPoint(x: icon.center.x, y: HeadReact.maxY))
        //添加活着Curve去定义一个或者多个subpaths
        pathone?.addQuadCurve(to: CGPoint(x:screenSize.width-25 , y:45), controlPoint: CGPoint.init(x: screenSize.width * 0.5, y: 80))
        carTableView.isUserInteractionEnabled = false
        doAnimation(iconView: icon)
    }
    
    func doAnimation(iconView:UIImageView) {
        
        let animationPath = CAKeyframeAnimation.init(keyPath: "position")
        animationPath.path = pathone?.cgPath
        animationPath.rotationMode = kCAAnimationRotateAuto
        
        let biganimation = CABasicAnimation.init(keyPath: "transform.scale")
        biganimation.beginTime = 0
        biganimation.fromValue = NSNumber(value: 1.0)
         biganimation.duration = 0.5
        biganimation.toValue = NSNumber(value: 2.0)
        biganimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        let smallanimation = CABasicAnimation.init(keyPath: "transform.scale")
        smallanimation.beginTime = 0.5
        smallanimation.fromValue = NSNumber(value: 2.0)
        smallanimation.duration = 1.5
        smallanimation.toValue = NSNumber(value: 0.5)
        smallanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let grouanimation = CAAnimationGroup()
        grouanimation.animations = [animationPath,biganimation,smallanimation]
        grouanimation.duration = 2
        grouanimation.delegate = self
        grouanimation.fillMode = kCAFillModeForwards;
        grouanimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        layer?.add(grouanimation, forKey: "groupAnimation")
        
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        layer?.removeFromSuperlayer()
        let shakeanimation = CABasicAnimation.init(keyPath: "transform.translation.y")
        shakeanimation.toValue = 5
        shakeanimation.fromValue = -5
        shakeanimation.duration = 0.5
        button_two.layer.add(shakeanimation, forKey: nil)
        carTableView.isUserInteractionEnabled = true
        
    }
    
}
