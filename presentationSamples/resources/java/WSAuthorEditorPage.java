/*
 * Copyright (c) 2018 Syncro Soft SRL - All Rights Reserved.
 *
 * This file contains proprietary and confidential source code.
 * Unauthorized copying of this file, via any medium, is strictly prohibited.
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
