Template.menuItemView.onCreated ->
  @sortOptions = new ReactiveVar sort: date: 1


Template.menuItemView.helpers
  menuItem: ->
    MenuItems.findOne()
  dailySales: ->
    sortOptions = Template.instance().sortOptions.get()
    DailySales.find {}, sortOptions


Template.menuItemView.events
  "click .delete-menu-item-button": () ->
    deleteMenuItemAction()

    # event for sort table with dailySales
  'click .sort-button': (e, tmpl) ->
    sortBy = $(e.currentTarget).attr 'id'
    sortOptions = currentSortOptions = tmpl.sortOptions
    sortDailySalesByField sortBy, sortOptions

  'click .predict-button': (e, tmpl) ->
    menuItemId = MenuItems.findOne()._id
    numberOfDaysOfPrediction = 10
    Meteor.call 'predictSalesForMenuItem', menuItemId, numberOfDaysOfPrediction, (err, res) ->
      if err
        console.log err
      else
        console.log res

deleteMenuItemAction = ->
  swal {
      title: 'Are you sure?'
      text: 'You will not be able to recover this menu item!'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Yes, delete it!'
      cancelButtonText: 'No, cancel!'
      closeOnConfirm: false
      closeOnCancel: false 
    }, (confirmed) =>
      if confirmed
        thisMenuItemId = MenuItems.findOne()._id
        # prevent from casual deleting menu item
        # Meteor.call "deleteMenuItem", thisMenuItemId, (err, res) ->
        #   if err
        #     swal 'Error', 'Was something wrong!', 'error'
        #   else
        #     swal 'Deleted', 'Menu item was deleted successfully', 'success'
        swal 'Error', 'Was something wrong!', 'error'
        Router.go "menuItems"
      else
        swal 'Cancelled', 'Menu item was not deleted', 'error'
      return

sortDailySalesByField = (sortBy, sortOptions)->
  currentSortOptions = sortOptions.get()
  newSortOptions = sort: {}
  newSortOptions.sort[sortBy] = if currentSortOptions.sort[sortBy] == 1 then -1 else  1
  sortOptions.set newSortOptions