
Pod::Spec.new do |s|
s.name             = "CRRefreshControl"
s.version          = "0.1.0"
s.summary          = "PullToRefresh, InfiniteScroll, custom animation, custom RefreshControl"

s.description      = "CRRefreshControl provides mechanism for CRPullToRefresh and CRInfiniteScroll,
and some default animations. You can you one of the or just create your own! Without deep in these classes,
just inherit CRRefreshAnimation and implement requirement methods, then just allow CRRefreshControl to drive theirs life cycle"

s.homepage         = "https://redmine.cleveroad.com:4443/CRpods/CRRefreshControl"
s.license          = 'MIT'
s.author           = { "Dmitry Pashinskiy" => "pashinskiy.kh.cr@gmail.com" }
s.source           = { :git => "https://redmine.cleveroad.com:4443/CRpods/CRRefreshControl.git", :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'CRRefreshControl/Classes/**/*'

end
