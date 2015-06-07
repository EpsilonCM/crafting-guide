###
Crafting Guide - markdown_image_list_controller.coffee

Copyright (c) 2015 by Redwood Labs
All rights reserved.
###

BaseController          = require './base_controller'
{Event}                 = require '../constants'
MarkdownImageController = require './markdown_image_controller'
MarkdownImageList       = require '../models/markdown_image_list'

########################################################################################################################

module.exports = class MarkdownImageListController extends BaseController

    constructor: (options={})->
        options.model ?= new MarkdownImageList {}, {client:options.client}
        options.templateName = 'markdown_image_list'
        super options

        @imageBase = ''

    # Public Methods ###############################################################################

    loadImages: ->
        @model.loadImages()

    # Property Methods #############################################################################

    getImageBase: ->
        return @_imageBase

    setImageBase: (newImageBase)->
        oldImageBase = @_imageBase
        return unless oldImageBase isnt newImageBase

        @_imageBase = newImageBase
        @trigger Event.change + ':imageBase', this, oldImageBase, newImageBase
        @trigger Event.change, this

    getMarkdownText: ->
        return @model.markdownText

    setMarkdownText: (markdownText)->
        @model.markdownText = markdownText

    Object.defineProperties @prototype,
        imageBase:    {get:@prototype.getImageBase,    set:@prototype.setImageBase}
        markdownText: {get:@prototype.getMarkdownText, set:@prototype.setMarkdownText}

    # BaseController Overrides #####################################################################

    onDidRender: ->
        @$imageContainer = @$('.image_container')
        super

    refresh: ->
        @_controllers ?= []
        index = 0

        for image in @model.all
            controller = @_controllers[index]
            if not controller?
                controller = new MarkdownImageController model:image
                @_controllers.push controller
                @$imageContainer.append controller.$el
                controller.render()
            else
                controller.model = image

            index += 1

        while @_controllers.length > index
            @_controllers.pop().remove()
