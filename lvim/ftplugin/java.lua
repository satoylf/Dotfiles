require('jdtls').start_or_attach({
  cmd = { 'jdtls' },
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
})
