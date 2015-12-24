Template.menuItemslistItem.helpers
  menuItem: ->
    Template.instance().data.menuItem

Template.menuItemslistItem.events
  "click .menu-item": (e, tmpl) ->
    menuItemId = tmpl.data.menuItem._id
    Router.go "menuItemView", id: menuItemId