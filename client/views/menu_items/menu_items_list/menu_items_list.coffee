Template.menuItems.onCreated ->
  @sortOptions = new ReactiveVar sort: name: 1


Template.menuItems.helpers
  menuItems: ->
    sortOptions = Template.instance().sortOptions.get()
    MenuItems.find {}, sortOptions


Template.menuItems.events
  # event for sort table
  'click .sort-button': (e, tmpl) ->
    currentSortOptions = tmpl.sortOptions.get()
    sortBy = $(e.currentTarget).attr 'id'
    newSortOptions = sort: {}
    newSortOptions.sort[sortBy] = if currentSortOptions.sort[sortBy] == 1 then -1 else  1
    tmpl.sortOptions.set newSortOptions

  'click .add-menu-item-button': ->
    