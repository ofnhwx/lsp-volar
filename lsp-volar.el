;;; lsp-volar.el --- description -*- lexical-binding: t; -*-

;; Copyright (C) 2021 Yuta Fujita

;; Author: Yuta Fujita <ofnhwx@komunan.net>
;; Keywords: lsp, languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; lsp-volar client

;;; Code:

(require 'lsp-mode)

(defgroup lsp-volar nil
  "Volar language server group."
  :group 'lsp-mode
  :link '(url-link "https://github.com/johnsoncodehk/volar"))

(lsp-dependency 'volar-server
                '(:system "volar-server")
                '(:npm :package "@volar/server" :path "volar-server"))

(lsp-register-custom-settings
 '(("volar.typescript.serverPath" (lambda ()
                              (expand-file-name "node_modules/typescript/lib/tsserverlibrary.js"
                                                (lsp-workspace-root))))
   ("volar.languageFeatures.callHierarchy" t t)
   ("volar.languageFeatures.codeAction" t t)
   ("volar.languageFeatures.codeLens" t t)
   ("volar.languageFeatures.completion.getDocumentNameCasesRequest" nil t)
   ("volar.languageFeatures.completion.getDocumentSelectionRequest" nil t)
   ("volar.languageFeatures.completions.defaultAttrNameCase" "kebabCase")
   ("volar.languageFeatures.completions.defaultTagNameCase" "both")
   ("volar.languageFeatures.definition" t t)
   ("volar.languageFeatures.diagnostics" t t)
   ("volar.languageFeatures.documentHighlight" t t)
   ("volar.languageFeatures.documentLink" t t)
   ("volar.languageFeatures.hover" t t)
   ("volar.languageFeatures.references" t t)
   ("volar.languageFeatures.rename" t t)
   ("volar.languageFeatures.renameFileRefactoring" t t)
   ("volar.languageFeatures.schemaRequestService" t t)
   ("volar.languageFeatures.semanticTokens" t t)
   ("volar.languageFeatures.signatureHelp" t t)
   ("volar.languageFeatures.typeDefinition" t t)
   ("volar.languageFeatures.workspaceSymbol" t t)
   ("volar.documentFeatures.documentColor" t t)
   ("volar.documentFeatures.selectionRange" t t)
   ("volar.documentFeatures.foldingRange" t t)
   ("volar.documentFeatures.linkedEditingRange" t t)
   ("volar.documentFeatures.documentSymbol" t t)
   ("volar.documentFeatures.documentFormatting.defaultPrintWidth" 100)
   ("volar.documentFeatures.documentFormatting.getDocumentPrintWidthRequest" nil t)
   ))

(defun volar-options ()
  (ht-get (lsp-configuration-section "volar") "volar"))

(defun volar-new-connection ()
  (cons (lsp-package-path 'volar-server)
        '("--stdio")))

(defun volar-download-server-fn (_client callback error-callback _update?)
  (lsp-package-ensure 'volar-server
                      callback error-callback))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection 'volar-new-connection)
  :major-modes '(vue-mode)
  :server-id 'volar
  :multi-root t
  :initialization-options 'volar-options
  :download-server-fn 'volar-download-server-fn))

(provide 'lsp-volar)
;;; lsp-volar.el ends here
