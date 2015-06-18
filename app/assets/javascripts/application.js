// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
function my_functions()
	{
		chngNotePosition();
		blockWrapWidth();
		bottomControl();
		//$('#test').text(0);
		$(".prodBlock").hover(function(){
												//$("#test").text('1');
												//hoverOffProdBlock();
												if ($(this).find('#prodBlockFog').css('opacity') != 0.5)
												$(this).find('#prodBlockFog').animate({'opacity':0.5}, 500);
										},
							  function(){
												//$("#test").text('1');
												//hoverOffProdBlock();
												if ($(this).find('#prodBlockFog').css('opacity') != 0.0)
												$(this).find('#prodBlockFog').animate({'opacity':0.0}, 200);
										});
		$("textarea").change(function(){bottomControl();});
		$(window).resize(function(){chngNotePosition(); blockWrapWidth();bottomControl();});
		$(window).scroll(function(){toggleNav();});

	}

function bottomControl()
	{
		var sum_h, window_h, new_cont_h;
		sum_h = $("#black_top").outerHeight() + $("#content").outerHeight() + $("#bottom").outerHeight() + $("#content_header").outerHeight();
		window_h = $(window).height();
		if (window_h > sum_h)
		{
			$("#bottom").css('position', 'fixed');
			$("#bottom").css('bottom', '0');
			new_cont_h = window_h - sum_h + $("#content").outerHeight();
			$("#content, #content_wrapper").height(new_cont_h);		
		}
		else
			{
			$("#bottom").css('position', 'relative');
			}
		
	}
	
function toggleNav()
	{
		var txt;
		txt = $("body").scrollTop();
		if (txt > 30) {$("#top_panel").css('background-color', 'black')}
		else {$("#top_panel").css('background-color', '')}
	}
function chngNotePosition()
	{
		var noteFontSize, noteRightOffset, window_w, defaultOffset, defaultFontSize, defaultWidth, noteWidth;
		window_w = parseFloat($(window).width());
		defaultFontSize = 35;
		defaultOffset = 150;
		defaultWidth = 500;
		if (window_w < 1601 & window_w > 1000)
		{
			noteFontSize = (defaultFontSize-10)+(10)*((window_w*window_w)/(1600*1600));
			noteRightOffset = (defaultOffset-100)+100*((window_w-1000)/600);
			noteWidth = (defaultWidth-100)+100*((window_w-1000)/600);
		}
		else if (window_w < 1001) {
									noteFontSize = (defaultFontSize-10)+(10)*((1000*1000)/(1600*1600));
									noteRightOffset =(defaultOffset-100);
									noteWidth = (defaultWidth-100);	
								  }
		else if (window_w > 1600) {noteRightOffset = defaultOffset; noteFontSize = defaultFontSize; noteWidth = defaultWidth;}
		if (window_w > 1200) {$('#sinceLogo').hide();$('#sinceNote').show();}
		else {$('#sinceLogo').show();$('#sinceNote').hide();}
		$('#note_top').css('right', noteRightOffset + 'px'); 
		$('#bigFontNote').css('font-size', noteFontSize + 'px');
		$('#note_top').width(noteWidth);
	}
function blockWrapWidth()
	{
		var font_size;
		font_size = $('.prodBlock').width()/10;
		$('.prodBlock').height($('.prodBlock').width()*9/16);
		$('#block_wrap').width($('.prodBlock').outerWidth()*3);
		$('.prodBlockText').css('font-size', font_size + 'px');
	}
	
