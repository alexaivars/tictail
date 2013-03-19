  # Client-side routes
  Sammy () ->
    @get '/products', () ->
      console.log "list all products"
      # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
      return
    @get /\#\/products\/(.*)/, () ->
      console.log "list #{@params['splat']} products"
      # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
      return
    @get /\#\/product\/(.*)/, () ->
      console.log "show product #{@params['splat']}"
      # $.get("/mail", { folder: this.params.folder }, self.chosenFolderData)
      return
    @get /\#\/(.*)/, () ->
      console.log "show other #{@params['splat']}"
      return
    @get '', () ->
      console.log "show default"
      return
  .run()





