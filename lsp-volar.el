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
   ("volar-api.languageFeatures.callHierarchy" t t)
   ("volar-api.languageFeatures.codeAction" t t)
   ("volar-api.languageFeatures.completion.getDocumentNameCasesRequest" nil t)
   ("volar-api.languageFeatures.completion.getDocumentSelectionRequest" nil t)
   ("volar-api.languageFeatures.completions.defaultAttrNameCase" "kebabCase")
   ("volar-api.languageFeatures.completions.defaultTagNameCase" "both")
   ("volar-api.languageFeatures.definition" t t)
   ("volar-api.languageFeatures.hover" t t)
   ("volar-api.languageFeatures.references" t t)
   ("volar-api.languageFeatures.rename" t t)
   ("volar-api.languageFeatures.renameFileRefactoring" t t)
   ("volar-api.languageFeatures.schemaRequestService" t t)
   ("volar-api.languageFeatures.signatureHelp" t t)
   ("volar-api.languageFeatures.typeDefinition" t t)
   ("volar-api.languageFeatures.workspaceSymbol" t t)
   ("volar-doc.languageFeatures.codeLens" t t)
   ("volar-doc.languageFeatures.diagnostics" t t)
   ("volar-doc.languageFeatures.documentHighlight" t t)
   ("volar-doc.languageFeatures.documentLink" t t)
   ("volar-doc.languageFeatures.semanticTokens" t t)
   ("volar-html.documentFeatures.documentColor" t t)
   ("volar-html.documentFeatures.selectionRange" t t)
   ("volar-html.documentFeatures.foldingRange" t t)
   ("volar-html.documentFeatures.linkedEditingRange" t t)
   ("volar-html.documentFeatures.documentSymbol" t t)
   ("volar-html.documentFeatures.documentFormatting.defaultPrintWidth" 100)
   ("volar-html.documentFeatures.documentFormatting.getDocumentPrintWidthRequest" nil t)
   ))

(defun volar-api-options ()
  (ht-merge (ht-get (lsp-configuration-section "volar") "volar")
            (ht-get (lsp-configuration-section "volar-api") "volar-api")))

(defun volar-doc-options ()
  (ht-merge (ht-get (lsp-configuration-section "volar") "volar")
            (ht-get (lsp-configuration-section "volar-doc") "volar-doc")))

(defun volar-html-options ()
  (ht-merge (ht-get (lsp-configuration-section "volar") "volar")
            (ht-get (lsp-configuration-section "volar-html") "volar-html")))

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
  :server-id 'volar-api
  :multi-root t
  :initialization-options 'volar-api-options
  :download-server-fn 'volar-download-server-fn))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection 'volar-new-connection)
  :major-modes '(vue-mode)
  :server-id 'volar-doc
  :multi-root t
  :add-on? t
  :initialization-options 'volar-doc-options
  :download-server-fn 'volar-download-server-fn))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection 'volar-new-connection)
  :major-modes '(vue-mode)
  :server-id 'volar-html
  :multi-root t
  :add-on? t
  :initialization-options 'volar-html-options
  :download-server-fn 'volar-download-server-fn))

(provide 'lsp-volar)
;;; lsp-volar.el ends here
