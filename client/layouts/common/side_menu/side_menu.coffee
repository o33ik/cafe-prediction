Template.sideMenu.events 
  "click .sidebar-item-menu": ->
    Router.go "menuItems"
  "click .sidebar-item-settings": ->
    Router.go "settings"
  "click .sidebar-item-prediction": ->
  	Router.go "prediction"