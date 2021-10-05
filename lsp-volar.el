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

(defun lsp-volar--make-init-options ()
  "Init options for Volar."
  (ht ("typescript" (ht ("serverPath" (expand-file-name "node_modules/typescript/lib/tsserverlibrary.js" (lsp-workspace-root)))))
      ("languageFeatures" (ht ("callHierarchy" t)
                              ("codeAction" t)
                              ("codeLens" t)
                              ("completion" (ht ("defaultTagNameCase" "both")
                                                ("defaultAttrNameCase" "kebabCase")))
                              ("definition" t)
                              ("diagnostics" t)
                              ("documentHighlight" t)
                              ("documentLink" t)
                              ("hover" t)
                              ("references" t)
                              ("rename" t)
                              ("renameFileRefactoring" t)
                              ("schemaRequestService" t)
                              ("semanticTokens" t)
                              ("signatureHelp" t)
                              ("typeDefinition" t)))
      ("documentFeatures" (ht ("documentColor" t)
                              ("selectionRange" t)
                              ("foldingRange" t)
                              ("linkedEditingRange" t)
                              ("documentSymbol" t)
                              ("documentFormatting" (ht ("defaultPrintWidth" 100)))))))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection
                   (lambda ()
                     (cons (lsp-package-path 'volar-server)
                           '("--stdio"))))
  :major-modes '(vue-mode)
  :initialization-options 'lsp-volar--make-init-options
  :server-id 'volar
  :download-server-fn (lambda (_client callback error-callback _update?)
                        (lsp-package-ensure 'volar-server
                                            callback error-callback))))

(provide 'lsp-volar)
;;; lsp-volar.el ends here
