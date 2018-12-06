/*
 * Copyright (c) 2018 Syncro Soft SRL - All Rights Reserved.
 *
 * This file contains proprietary and confidential source code.
 * Unauthorized copying of this file, via any medium, is strictly prohibited.
 */
package ro.sync.exml.workspace.api.editor;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.net.URL;

import ro.sync.annotations.api.API;
import ro.sync.annotations.api.APIType;
import ro.sync.annotations.api.SourceType;
import ro.sync.exml.workspace.api.editor.documenttype.DocumentTypeInformation;
import ro.sync.exml.workspace.api.editor.transformation.TransformationScenarioInvoker;

/**
 * Provides access to methods related to the editor actions and information.
 * 
 * @since 11.2 
 */
@API(type=APIType.NOT_EXTENDABLE, src=SourceType.PUBLIC)
public interface WSEditorBase extends TransformationScenarioInvoker {
  /**
   * Get the {@link URL} representing the editor location.
   * 
   * @return The editor location. It cannot be <code>null</code>.
   */
  URL getEditorLocation();
  
  /**
   * Saves the editor content.
   */
  void save();
  
  /**
   * Saves the editor content to a new location. 
   * This method is not implemented in the Oxygen Eclipse plugin.
   * 
   * @param location The new editor location.
   * 
   * @since 13
   */
  void saveAs(URL location);
  
  /**
   * Closes the current editor.
   * <p>
   * If the editor has unsaved content and <code>askForSave</code> is
   * <code>true</code>, the user will be given the opportunity to save it.
   * </p>
   * 
   * @param askForSave <code>true</code> to save the editor contents if required,
   *            and <code>false</code> to discard any unsaved changes.
   * @return <code>true</code> if the editor was successfully closed, and
   *         <code>false</code> if the editor is still open
   */
  boolean close(boolean askForSave);
  
  /**
   * This method can be used to determine if the document from the editor contains unsaved modifications.
   * 
   * @return <code>true</code> if the document in the current editor contains unsaved modifications. 
   */
  boolean isModified();
  
  /**
   * Set the modified status of the editor document.
   * 
   * For SWT the result of this method is guaranteed only when working exclusively with the author page. 
   * If the text page contains modifications (and is marked as dirty) this method is unable to change its state 
   * to unmodified. 
   * 
   * @param modified <code>true</code> if the document in the current editor contains unsaved modifications. 
   */
  void setModified(boolean modified);
  
  /**
   * This method can be used to determine if the document from the editor was ever saved.
   * 
   * @return <code>true</code> if the document in the current editor is new. 
   */
  boolean isNewDocument();
  
  /**
   * Create a reader over the whole editor's content (exactly the XML content which gets saved on disk).
   * The unsaved changes are included. If for the Author page change tracking highlights are present, they are also included as processing instructions.
   * @see ro.sync.ecss.markers.MarkerConstants for the processing instruction names
   * 
   * @return The content reader.In normal circumstances the reader should not be <code>null</code>.
   */
  Reader createContentReader();
  
  /**
   * Create a properly encoded input stream reader over the whole editor's content (exactly the XML content which gets saved on disk).
   * The unsaved changes are included. If for the Author page change tracking highlights are present, they are also included as processing instructions.
   * @see ro.sync.ecss.markers.MarkerConstants for the processing instruction names
   * 
   * @return An input stream over the XML contents.In normal circumstances the input stream should not be <code>null</code>.
   * @throws IOException 
   * 
   * @since 15.2
   */
  InputStream createContentInputStream() throws IOException;
  
  /**
   * Update the whole content of the editor with the one taken from the reader.
   * This will lose undo history and any modifications the editor may have.
   * 
   * @param reader The reader provided by the extension.
   */
  void reloadContent(Reader reader);
  
  /**
   * Update the whole content of the editor with the one taken from the reader.
   * This will lose any modifications the editor may have unless discardUndoableEdits
   * is <code>false</code> in which case you will be able to UNDO the editor
   * to the content prior to the reload.
   * 
   * @param reader The reader provided by the extension.
   * @param discardUndoableEdits <code>true</code> to lose undo history.
   * 
   * @since 13.2
   */
  void reloadContent(Reader reader, boolean discardUndoableEdits);
  
  /**
   * Set the text which appears on the editor's tab, by default it is the loaded file name.
   * Set it with the value NULL to reset the tab title to the default value (the loaded file name).
   * 
   * @param tabText the text which appears on the editor's tab, by default it is the loaded file name.
   * NULL to reset the tab title to the default value (the loaded file name).
   * 
   * @since 12.1
   */
  void setEditorTabText(String tabText);
  
  /**
   * Set the tooltip text for the editor's tab, by default it is the loaded file path.
   * Set it with the value NULL to reset the tab title to the default value (the loaded file path).
   * 
   * @param tabTooltip the tooltip for the editor's tab, by default it is the loaded file path.
   * NULL to reset the tab tooltip to the default value (the loaded file path).
   * 
   * @since 12.1
   */
  void setEditorTabTooltipText(String tabTooltip);
  
  /**
   * Get information about the current document type configuration used to edit the XML document.
   * @return information about the current document type configuration used to edit the XML document or <code>null</code> if no document type
   * configuration is matched or the editor does not have an XML content type.
   * 
   * @since 16.1
   * 
   * <br>
   * <br>
   * *********************************
   * <br>
   * EXPERIMENTAL - Subject to change
   * <br>
   * ********************************
   * </br>
   * <p>Please note that this API is not marked as final and it can change in one of the next versions of the application. If you have suggestions, 
   * comments about it, please let us know.</p>
   */
  DocumentTypeInformation getDocumentTypeInformation();
}