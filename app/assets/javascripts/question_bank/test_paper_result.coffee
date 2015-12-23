class TestPaperResult
  constructor: (@$ele)->
    @bind_submit_event()

  bind_submit_event: ->
    @$ele.on 'submit', 'form', (evt)=>
      evt.preventDefault()
      $target = jQuery evt.target
      data    = $target.serializeArray()

      jQuery.ajax
        url: $target.attr("action")
        method: "POST"
        data: data
      .success (msg) =>
        @$ele.find('.glyphicon-remove.red').addClass('hidden')
        msgs = $.map msg, (key,value)->
          [[key,value]]
        for x in [0..msgs.length-1]
          if msgs[x][0].is_correct is false
            $area = @$ele.find("[data=#{msgs[x][1]}]")
            $area.find('.glyphicon-remove.red').removeClass('hidden')

jQuery(document).on 'ready page:load', ->
  if jQuery('.page-test-paper-result-new').length > 0
    new TestPaperResult jQuery('.page-test-paper-result-new')

