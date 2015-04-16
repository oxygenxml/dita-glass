/*
 *  The Syncro Soft SRL License
 *
 *  Copyright (c) 1998-2007 Syncro Soft SRL, Romania.  All rights
 *  reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistribution of source or in binary form is allowed only with
 *  the prior written permission of Syncro Soft SRL.
 *
 *  2. Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *
 *  3. Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in
 *  the documentation and/or other materials provided with the
 *  distribution.
 *
 *  4. The end-user documentation included with the redistribution,
 *  if any, must include the following acknowledgment:
 *  "This product includes software developed by the
 *  Syncro Soft SRL (http://www.sync.ro/)."
 *  Alternately, this acknowledgment may appear in the software itself,
 *  if and wherever such third-party acknowledgments normally appear.
 *
 *  5. The names "Oxygen" and "Syncro Soft SRL" must
 *  not be used to endorse or promote products derived from this
 *  software without prior written permission. For written
 *  permission, please contact support@oxygenxml.com.
 *
 *  6. Products derived from this software may not be called "Oxygen",
 *  nor may "Oxygen" appear in their name, without prior written
 *  permission of the Syncro Soft SRL.
 *
 *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED.  IN NO EVENT SHALL THE SYNCRO SOFT SRL OR
 *  ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 *  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 *  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 *  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 */
package ro.sync.exml.workspace.api.editor.page.author;

import ro.sync.annotations.api.API;
import ro.sync.annotations.api.APIType;
import ro.sync.annotations.api.SourceType;
import ro.sync.ecss.extensions.api.AuthorAccess;
import ro.sync.ecss.extensions.api.AuthorChangeTrackingController;
import ro.sync.ecss.extensions.api.AuthorDocumentController;
import ro.sync.ecss.extensions.api.AuthorReviewController;
import ro.sync.ecss.extensions.api.OptionsStorage;
import ro.sync.ecss.extensions.api.access.AuthorOutlineAccess;
import ro.sync.ecss.extensions.api.access.AuthorTableAccess;

/**
 * Author editor page. 
 * 
 * @since 11.2 
 */
@API(type=APIType.NOT_EXTENDABLE, src=SourceType.PUBLIC)
public interface WSAuthorEditorPage extends WSAuthorEditorPageBase {

  /**
   * Returns the Author document controller. It has methods for changing the document model.
   * 
   * @return The controller for Author document. 
   * Cannot be <code>null</code>.
   */
  AuthorDocumentController getDocumentController();
  
  /**
   * Returns the author table access provider responsible for obtaining table
   * related information and executing table actions.
   * 
   * @return The table related information and actions provider. 
   * Cannot be <code>null</code>.
   */
  AuthorTableAccess getTableAccess();
  
  /**
   * The change tracking controller used to toggle change tracking on and off and
   * check its state.
   * 
   * @return The change tracking controller. 
   * Cannot be <code>null</code>.
   * 
   * @deprecated Use <code>{@link WSAuthorEditorPage#getReviewController()}</code> instead.
   */
  @Deprecated
  AuthorChangeTrackingController getChangeTrackingController();
  
  /**
   * Controller that can be used to toggle the change tracking state, modify the review 
   * highlight author name, the highlight painting or to obtain information
   * about the properties used in the serialization and representation of the review 
   * highlight (author name, reviewer auto color or the current time stamp in a format
   * identical to the one used by Oxygen for insert, delete and comment markers).  
   * 
   * @return The review controller.
   * Cannot be <code>null</code>.
   * @since 12
   */
  AuthorReviewController getReviewController();
  
  /**
   * The object that manages the options stored for author extensions. 
   * This is also responsible for adding and removing listeners that are notified
   * about the option changes.
   * 
   * @return The object that manages the options stored for author extensions.
   */
  OptionsStorage getOptionsStorage();
  
  /**
   * Get the author Outline access providing Outline related information.
   * 
   * @return The Outline related informations and actions provider.
   * Cannot be <code>null</code>.
   */
  AuthorOutlineAccess getOutlineAccess();
  
  /**
   * Access class to the author functions. 
   * The WSAuthorEditorPage has most of the methods which can also be found in the AuthorAccess.
   * This method is offered only as an useful way to have utility methods which take AuthorAccess as a parameter and 
   * to use them both from a plugin and from a framework.
   * 
   * Provides access to specific components corresponding to editor, document, workspace,
   * tables, change tracking and utility informations and actions.
   * 
   * @return The author access.
   * 
   * @since 14.1
   */
  AuthorAccess getAuthorAccess();
}
