augroup show_diff_for_commit_window
  autocmd!
  autocmd BufRead COMMIT_EDITMSG call debrief#OpenDiffPane()
augroup END
