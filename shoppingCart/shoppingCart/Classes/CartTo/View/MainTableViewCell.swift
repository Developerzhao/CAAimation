//
//  MainTableViewCell.swift
//  shoppingCart
//
//  Created by Ken on 2020/5/7.
//  Copyright © 2020 罗连喜. All rights reserved.
//

import UIKit

protocol MainToTableViewCellDelegate:NSObjectProtocol {
    //代理方法
    func clickTransmitData(cell:MainTableViewCell ,icon: UIImageView)
}

class MainTableViewCell: UITableViewCell {
    
    
    var goodModel : AJGoodModel? {
        didSet{
            if let iconName = goodModel?.iconName{
                imageview.image = UIImage(named: iconName)
            }
            if  let desc = goodModel?.desc {
                descLabel.text = desc
            }
            
            if let title = goodModel?.title {
                title_lable.text = title
            }
            
            //已经点击就禁用,防止cell的重用
            addCarButton.isSelected = !goodModel!.alreadyAddShoppingCArt
            
        }
    }
   weak var delegate:MainToTableViewCellDelegate?
    //回调给控制器的商品图片
    var collBackIconView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {
        
        //添加子控件
        contentView.addSubview(imageview)
        contentView.addSubview(title_lable)
        contentView.addSubview(descLabel)
        contentView.addSubview(addCarButton)
        //约束子控件
        imageview.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.top.equalTo(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        title_lable.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(imageview.snp_right).offset(12)
        }
        descLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(title_lable.snp_bottom).offset(12)
            make.left.equalTo(imageview.snp_right).offset(12)
        }
        addCarButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-12)
            make.top.equalTo(25)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
    }
    
    @objc func addCarButtonClick(btn:UIButton){
        
        //已经点击就禁用,防止cell的重用
        goodModel!.alreadyAddShoppingCArt = !goodModel!.alreadyAddShoppingCArt
//        btn.backgroundColor
        btn.isEnabled = !goodModel!.alreadyAddShoppingCArt
        delegate?.clickTransmitData(cell:self, icon: imageview)
        
       
    }
    
    fileprivate lazy var imageview: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        return image
    }()
    // MARK: -
    fileprivate lazy var title_lable : UILabel = {
        var title = UILabel()
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 13)
        title.textAlignment = NSTextAlignment.left
        return title
    }()
    
    //商品描述
    fileprivate lazy var descLabel: UILabel = {
        let descLabel  = UILabel()
        descLabel.textColor = UIColor.gray
        return descLabel
    }()
    
    //添加按钮
    fileprivate lazy var addCarButton: UIButton = {
        
        let addCarButton = UIButton(type: UIButtonType.custom)
        addCarButton.setBackgroundImage(UIImage(named: "button_add_cart"), for: .normal)
        addCarButton.setTitle("购买", for: UIControlState())
        //按钮的点击事件
        addCarButton.addTarget(self, action: #selector(addCarButtonClick(btn:)), for: UIControlEvents.touchUpInside)
        return addCarButton
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
