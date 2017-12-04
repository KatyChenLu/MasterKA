//2.2.8 message error
 require('NSString,UIStoryboard,NSBundle');
var appVersionString = require('NSBundle').mainBundle().infoDictionary().objectForKey("CFBundleShortVersionString");
if(appVersionString.isEqualToString("3.0.1")){
    defineClass('SystemMessageViewController', {
                tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
                var row = indexPath.row();
                var item = self.dataSource().objectAtIndex(row);
                var targetType = item.objectForKey("target_type");
                //（1：课程；2：达人；3：课程卡片；4：达人卡片；5：html5页面；6：课程关键字）'
                if (targetType) {
                var targetContent = item.objectForKey("target_content");
                if (targetType.integerValue() == 1) {
                var story = UIStoryboard.storyboardWithName_bundle("Goods", NSBundle.mainBundle());
                var myView = story.instantiateViewControllerWithIdentifier("GoodDetailViewController");
                myView.setParams({
                                 "courseId": targetContent
                                 });
                self.navigationController().pushViewController_animated(myView, YES);
                } else if (targetType.integerValue() == 2) {
                var url = NSString.stringWithFormat("master://nmuser_master?uid=%@", targetContent);
                self.pushViewControllerWithUrl(url);
                } else if (targetType.integerValue() == 5) {
                self.pushViewControllerWithUrl(targetContent);
                } else if (targetType.integerValue() == 3 || targetType.integerValue() == 4) {
                self.pushViewControllerWithUrl(item.objectForKey("pfurl"));
                } else if (targetType.integerValue() == 6) {
                var story = UIStoryboard.storyboardWithName_bundle("MasterShare", NSBundle.mainBundle());
                var myView = story.instantiateViewControllerWithIdentifier("MasterShareSearchViewController");
                myView.setParams({"text": targetContent});
                self.pushViewController_animated(myView, YES);
                }
                }
                
                },
                });
    defineClass('SystemMessageTableViewCell', {
                setItemData: function(itemData) {
                self.clearCellData();
                if (itemData) {
                self.messageTitleView().setText(itemData.objectForKey("title"));
                self.messageDescView().setText(itemData.objectForKey("content"));
                self.messageTimeView().setText(itemData.objectForKey("add_time"));
                var picUrl = itemData.objectForKey("pic_url");
                if (picUrl && !picUrl.isEqualToString("")) {
                self.messageImageView().setImageWithURLString(picUrl);
                self.descToImgConstraint().setPriority(750);
                self.descToTitleConstraint().setPriority(250);
                self.messageImageView().setHidden(NO);
                }
                var targetType = itemData.objectForKey("target_type");
                //（1：课程；2：达人；3：课程卡片；4：达人卡片；5：html5页面；6：课程关键字）'
                if (targetType.integerValue() >= 1 ) {
                self.messageMoreView().setHidden(NO);
                self.moreLayoutHeight().setConstant(40);
                }
                }
                
                },
                });
    defineClass('GoodDetailModel', {
                setDiscountText: function(array) { //优惠券信息
                array = array.toJS()
                 console.log(array);
                var str = "";
                for (var discount in array) {
                if (array.length > 1) {
                console.log(discount);
                str = str +array[discount] +",";
                } else {
                    str = array[discount];
                }
                }
                if (array.length > 1) {
                return str.substr(0,str.length-1);
                }
                return str;
                },
                });
}