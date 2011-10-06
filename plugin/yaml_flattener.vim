if exists("g:loaded_YAMLFlattener")
  finish
endif

let g:loaded_YAMLFlattener = 1

if !has("ruby")
    echohl ErrorMsg
    echon "Sorry, the YAML Flattener plugin requires Ruby support."
  finish
endif

let g:YAMLFlattener_key = '<Leader>r'
if has("gui_macvim")
  let g:YAMLFlattener_key = '<D-r>'
end

" Thanks to https://github.com/hotchpotch/meta_framework-vim/blob/95eb37317eef061cec75c308eae273cc4256e1aa/meta_framework.vim#L23
let s:libfile = fnamemodify(resolve(expand('<sfile>:p')), ':p:h') . '/../lib/yamlator.rb'
execute 'rubyfile ' . s:libfile

ruby << EOF

  def yaml_toggle_flatness
    if read_buffer.match(/^\w+\./)
      replace_buffer YAMLator.new(read_buffer).to_nested_yaml
    else
      replace_buffer YAMLator.new(read_buffer).to_flat_yaml
    end
  end

  def read_buffer
    buffer = VIM::Buffer.current
    (1..(buffer.count)).map { |i| buffer[i] }.join("\n")
  end

  def replace_buffer(text)
    buffer = VIM::Buffer.current
    buffer.count.downto(1) { |i| buffer.delete(i) }
    text.lines.each_with_index { |x, i| buffer.append(i, x.chomp) }
  end

EOF

function! s:YAMLToggleFlatness()
  ruby yaml_toggle_flatness
  normal! gg
endfunction

command! YAMLToggleFlatness call <SID>YAMLToggleFlatness()

if !hasmapto("YAMLToggleFlatness") && has("autocmd")
  exec 'au FileType yaml map <buffer> ' . g:YAMLFlattener_key . ' :YAMLToggleFlatness<CR>'
endif
