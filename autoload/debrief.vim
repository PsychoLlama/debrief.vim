let s:GIT_PANE_FLAG = 'debrief__is_git_pane'

func! s:CreateGitDiffPane() abort
  vsplit Diff
  setfiletype diff

  let b:[s:GIT_PANE_FLAG] = v:true
  setlocal nowriteany nobuflisted nonumber
  setlocal buftype=nowrite bufhidden=delete signcolumn=no
endfunc

func! s:GetDiffContent() abort
  let l:diff_lines = systemlist('git diff --staged')

  " Show full diff for amended commits.
  if len(l:diff_lines) == 0
    let l:diff_lines = systemlist('git diff HEAD^')
  endif

  return l:diff_lines
endfunc

func! debrief#OpenDiffPane() abort
  " :edit runs the file again. Don't show two panes.
  if debrief#IsShowingDiffPane()
    return
  endif

  let s:mount_point = winwidth('.') >= 72 * 2 ? 'L' : 'J'
  call s:CreateGitDiffPane()
  execute 'wincmd ' . s:mount_point

  let l:diff_lines = s:GetDiffContent()
  call setline(1, l:diff_lines)
  setlocal nomodifiable

  " Put focus back on the commit window.
  let s:focus_point = s:mount_point is# 'L' ? 'h' : 'k'
  execute 'wincmd ' . s:focus_point
endfunc

func! s:IsActiveBuffer(index, buffer) abort
  return a:buffer.loaded && !a:buffer.hidden
endfunc

" Get every non-backgrounded buffer object.
func! s:GetActiveBufferList() abort
  let l:buffers = getbufinfo()
  return filter(l:buffers, function('s:IsActiveBuffer'))
endfunc

func! s:IsGitPane(index, buffer) abort
  return get(a:buffer.variables, s:GIT_PANE_FLAG, v:false)
endfunc

func! debrief#FindDiffPane() abort
  let l:buffers = s:GetActiveBufferList()
  call filter(l:buffers, function('s:IsGitPane'))

  if !len(l:buffers)
    return v:null
  endif

  return l:buffers[0]
endfunc

func! debrief#IsShowingDiffPane() abort
  return debrief#FindDiffPane() isnot# v:null
endfunc

func! s:CloseBufferById(id) abort
  execute a:id . 'bdelete'
endfunc

func! debrief#CloseDiffPane() abort
  if !debrief#IsShowingDiffPane()
    return
  endif

  let l:diff_buf_id = debrief#FindDiffPane().bufnr
  call s:CloseBufferById(l:diff_buf_id)
endfunc

func! s:CloseDiffIfLastWindow() abort
  " There's only one buffer left and it's the diff.
  if len(s:GetActiveBufferList()) is# 1 && debrief#IsShowingDiffPane()
    quit
  endif
endfunc

augroup close_diff_pane_if_terminated
  autocmd!
  autocmd BufEnter * call <SID>CloseDiffIfLastWindow()
augroup END
